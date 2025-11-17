import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:insan_jamd_hawan/core/services/openai/openai_credentials.dart';

class OpenAIClient {
  static final OpenAIClient instance = OpenAIClient._();
  OpenAIClient._();

  Dio? _dio;
  bool _isInitialized = false;

  void initialize({String? apiKey}) {
    try {
      final key = apiKey ?? OpenAICredentials.getApiKey();
      _dio =
          Dio(
              BaseOptions(
                baseUrl: OpenAICredentials.baseUrl,
                headers: {
                  'Authorization': 'Bearer $key',
                  'Content-Type': 'application/json',
                },
                validateStatus: (status) => status! < 500,
              ),
            )
            ..interceptors.add(
              LogInterceptor(
                request: true,
                requestHeader: true,
                requestBody: true,
                responseBody: true,
                error: true,
              ),
            );
      _isInitialized = true;
      developer.log('OpenAI client initialized', name: 'OpenAIClient');
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing OpenAI client: $e',
        name: 'OpenAIClient',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> evaluateAnswers({
    required String selectedLetter,
    required List<Map<String, dynamic>> playerAnswers,
    List<String>? categoriesToEvaluate,
  }) async {
    if (!_isInitialized || _dio == null) {
      throw Exception(
        'OpenAI client not initialized. Call initialize() first.',
      );
    }

    try {
      final prompt = _buildEvaluationPrompt(
        selectedLetter,
        playerAnswers,
        categoriesToEvaluate: categoriesToEvaluate,
      );

      final response = await _dio!.post(
        '/chat/completions',
        data: {
          'model': OpenAICredentials.model,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an expert game evaluator. Your role is to evaluate answers fairly and consistently according to the rules. Apply the same evaluation criteria to all players. Return only valid JSON in the exact format specified.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.1,
          'response_format': {'type': 'json_object'},
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'OpenAI API error: ${response.statusCode} - ${response.data}',
        );
      }

      final content =
          response.data['choices'][0]['message']['content'] as String;
      final jsonResponse = jsonDecode(content) as Map<String, dynamic>;

      developer.log('ChatGPT evaluation completed', name: 'OpenAIClient');

      return jsonResponse;
    } catch (e, stackTrace) {
      developer.log(
        'Error evaluating answers with ChatGPT: $e',
        name: 'OpenAIClient',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  String _buildEvaluationPrompt(
    String selectedLetter,
    List<Map<String, dynamic>> playerAnswers, {
    List<String>? categoriesToEvaluate,
  }) {
    // Normalize the selected letter to uppercase for consistent comparison
    final normalizedLetter = selectedLetter.toUpperCase();

    // Default to all categories if not specified
    final standardCategoryMap = {
      'name': 'Name',
      'object': 'Object',
      'animal': 'Animal',
      'plant': 'Plant',
      'country': 'Country',
    };

    // Filter categories if specific ones are requested
    Map<String, String> activeCategories = standardCategoryMap;
    if (categoriesToEvaluate != null && categoriesToEvaluate.isNotEmpty) {
      activeCategories = {};
      
      for (final categoryKey in categoriesToEvaluate) {
        final normalizedKey = categoryKey.toLowerCase();
        
        // Check if it's a standard category
        if (standardCategoryMap.containsKey(normalizedKey)) {
          activeCategories[normalizedKey] = standardCategoryMap[normalizedKey]!;
        } else {
          // For custom categories (like "tv show"), capitalize properly
          final displayName = _capitalizeCategory(categoryKey);
          activeCategories[normalizedKey] = displayName;
        }
      }
    }

    final buffer = StringBuffer();
    buffer.writeln(
      'Evaluate answers for a word game. The selected letter is "$normalizedLetter" (case-insensitive).',
    );
    buffer.writeln('');
    buffer.writeln('CRITICAL EVALUATION RULES:');
    buffer.writeln('');
    buffer.writeln('1. LETTER MATCHING (Case-Insensitive):');
    buffer.writeln(
      '   - Answers must start with the letter "$normalizedLetter" (case-insensitive).',
    );
    buffer.writeln(
      '   - Examples: If letter is "A", then "apple", "Apple", "APPLE", "Andrew" are all valid.',
    );
    buffer.writeln(
      '   - If an answer does NOT start with "$normalizedLetter" (ignoring case), mark as "incorrect".',
    );
    buffer.writeln('');
    buffer.writeln('2. EMPTY/INVALID ANSWERS:');
    buffer.writeln(
      '   - Empty strings, whitespace-only, or answers with only special characters = "incorrect" (0 points)',
    );
    buffer.writeln('');
    buffer.writeln('3. CATEGORY VALIDATION:');
    
    // Define validation rules for each category
    final categoryDescriptions = {
      'name': 'First names, last names, or common nicknames (e.g., "Alice", "Bob", "Mohammed")',
      'object': 'Physical objects, items, things (e.g., "apple", "book", "car")',
      'animal': 'Living creatures, animals (e.g., "ant", "elephant", "dog")',
      'plant': 'Trees, flowers, vegetables, fruits (e.g., "apple", "rose", "oak")',
      'country': 'Official country names (e.g., "Argentina", "Australia", "Afghanistan")',
    };
    
    activeCategories.forEach((key, displayName) {
      if (categoryDescriptions.containsKey(key)) {
        buffer.writeln('   - $displayName: ${categoryDescriptions[key]}');
      } else {
        // For custom categories, provide a generic description
        buffer.writeln(
          '   - $displayName: Valid entries that belong to this category and start with "$normalizedLetter"',
        );
      }
    });
    
    buffer.writeln(
      '   - If answer does not fit the category, mark as "incorrect"',
    );
    buffer.writeln('');
    buffer.writeln('4. DUPLICATE DETECTION (Case-Insensitive):');
    buffer.writeln(
      '   - Compare answers across ALL players for EACH category separately.',
    );
    buffer.writeln(
      '   - Duplicates are case-insensitive: "Apple" and "apple" are duplicates.',
    );
    buffer.writeln(
      '   - If multiple players have the same answer (ignoring case) in a category, ALL instances are "duplicate" (5 points each).',
    );
    buffer.writeln(
      '   - The FIRST player to submit is NOT automatically "correct" - ALL duplicates get 5 points.',
    );
    buffer.writeln('');
    buffer.writeln('5. UNCLEAR STATUS (Use Sparingly):');
    buffer.writeln(
      '   - Only use "unclear" for answers that are ambiguous proper nouns that cannot be definitively verified.',
    );
    buffer.writeln(
      '   - Examples: Obscure personal names, very rare places, or highly specialized terms.',
    );
    buffer.writeln(
      '   - If you can reasonably determine validity, use "correct" or "incorrect" instead.',
    );
    buffer.writeln('   - When in doubt, prefer "incorrect" over "unclear".');
    buffer.writeln('');
    buffer.writeln('6. NORMALIZATION:');
    buffer.writeln('   - Trim whitespace before evaluation.');
    buffer.writeln(
      '   - Compare answers ignoring case for duplicate detection.',
    );
    buffer.writeln('   - Check letter matching ignoring case.');
    buffer.writeln('');
    buffer.writeln('Player Answers:');
    for (final answer in playerAnswers) {
      buffer.writeln('Player ID: ${answer['playerId']}');
      final usedDoublePoints = answer['usedDoublePoints'] as bool? ?? false;
      if (usedDoublePoints) {
        buffer.writeln(
          '  [DOUBLE POINTS ACTIVE - Correct answers will be doubled]',
        );
      }
      final answers = answer['answers'] as Map<String, dynamic>;
      // Only show categories that are being evaluated
      activeCategories.forEach((key, displayName) {
        final answerText = answers[key]?.toString() ?? '';
        buffer.writeln('  $displayName: "$answerText"');
      });
      buffer.writeln('');
    }
    buffer.writeln('');
    buffer.writeln(
      'Return JSON in this exact format, using the EXACT player IDs from above:',
    );
    buffer.writeln('{');
    buffer.writeln('  "evaluations": {');
    buffer.writeln('    "EXACT_PLAYER_ID": {');
    // Build example format with only active categories
    final exampleStatuses = ['correct', 'duplicate', 'incorrect', 'unclear', 'correct'];
    int statusIndex = 0;
    activeCategories.forEach((key, displayName) {
      final status = exampleStatuses[statusIndex % exampleStatuses.length];
      final points = status == 'correct' ? 10 : (status == 'duplicate' ? 5 : 0);
      final comma = activeCategories.keys.last == key ? '' : ',';
      buffer.writeln('      "$displayName": {"status": "$status", "points": $points}$comma');
      statusIndex++;
    });
    buffer.writeln('    }');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln('');
    buffer.writeln('POINTS SYSTEM:');
    buffer.writeln('  - correct: 10 points (base, may be multiplied for special rounds)');
    buffer.writeln('  - duplicate: 5 points');
    buffer.writeln('  - incorrect: 0 points');
    buffer.writeln('  - unclear: 0 points');
    buffer.writeln('');
    buffer.writeln(
      'CRITICAL: Use the EXACT player IDs shown above (e.g., "${playerAnswers.isNotEmpty ? playerAnswers[0]['playerId'] : 'playerId'}"), NOT placeholders.',
    );
    buffer.writeln(
      'Evaluate consistently and fairly. Apply the same standards to all players.',
    );
    buffer.writeln(
      'ONLY evaluate the categories listed above. Do not include categories that are not in the player answers.',
    );

    return buffer.toString();
  }

  /// Capitalizes category name properly
  /// Examples: "tv show" -> "Tv Show", "name" -> "Name"
  String _capitalizeCategory(String category) {
    if (category.isEmpty) return category;
    
    // Split by spaces and capitalize each word
    final words = category.toLowerCase().split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).toList();
    
    return capitalizedWords.join(' ');
  }
}
