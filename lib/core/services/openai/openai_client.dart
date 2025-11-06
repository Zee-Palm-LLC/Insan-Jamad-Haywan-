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
  }) async {
    if (!_isInitialized || _dio == null) {
      throw Exception(
        'OpenAI client not initialized. Call initialize() first.',
      );
    }

    try {
      final prompt = _buildEvaluationPrompt(selectedLetter, playerAnswers);

      final response = await _dio!.post(
        '/chat/completions',
        data: {
          'model': OpenAICredentials.model,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an expert game evaluator. Evaluate answers strictly according to the rules and return only valid JSON.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.3,
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
    List<Map<String, dynamic>> playerAnswers,
  ) {
    final buffer = StringBuffer();
    buffer.writeln(
      'Evaluate answers for a word game. The selected letter is "$selectedLetter".',
    );
    buffer.writeln('');
    buffer.writeln('Rules:');
    buffer.writeln(
      '1. Each answer must start with the letter "$selectedLetter"',
    );
    buffer.writeln('2. Answers must be valid words in the specified category');
    buffer.writeln('3. Categories: Name, Object, Animal, Plant, Country');
    buffer.writeln('4. Evaluation statuses:');
    buffer.writeln(
      '   - "correct": Valid answer starting with "$selectedLetter"',
    );
    buffer.writeln(
      '   - "incorrect": Does not start with "$selectedLetter" or invalid',
    );
    buffer.writeln(
      '   - "unclear": Person/place/thing that cannot be verified',
    );
    buffer.writeln('   - "duplicate": Same answer as another player');
    buffer.writeln('');
    buffer.writeln('Player Answers:');
    for (final answer in playerAnswers) {
      buffer.writeln('Player: ${answer['playerId']}');
      final answers = answer['answers'] as Map<String, String>;
      answers.forEach((category, answerText) {
        buffer.writeln('  $category: $answerText');
      });
      buffer.writeln('');
    }
    buffer.writeln('');
    buffer.writeln(
      'Return JSON in this exact format, using the ACTUAL player IDs from above:',
    );
    buffer.writeln('{');
    buffer.writeln('  "evaluations": {');
    buffer.writeln('    "ACTUAL_PLAYER_ID_FROM_ABOVE": {');
    buffer.writeln('      "Name": {"status": "correct", "points": 10},');
    buffer.writeln('      "Object": {"status": "duplicate", "points": 5},');
    buffer.writeln('      "Animal": {"status": "incorrect", "points": 0},');
    buffer.writeln('      "Plant": {"status": "unclear", "points": 0},');
    buffer.writeln('      "Country": {"status": "correct", "points": 10}');
    buffer.writeln('    }');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln('');
    buffer.writeln(
      'IMPORTANT: Use the EXACT player IDs shown in the "Player Answers" section above (e.g., "aana", "aira"), NOT placeholder IDs like "playerId1".',
    );
    buffer.writeln('Points: correct=10, incorrect=0, unclear=0, duplicate=5');
    buffer.writeln(
      'Check for duplicates by comparing answers across all players for each category.',
    );

    return buffer.toString();
  }
}
