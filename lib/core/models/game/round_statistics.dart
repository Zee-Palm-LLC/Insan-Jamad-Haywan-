import 'package:freezed_annotation/freezed_annotation.dart';

part 'round_statistics.freezed.dart';
part 'round_statistics.g.dart';

@freezed
class RoundStatistics with _$RoundStatistics {
  const factory RoundStatistics({
    final String? fakeAnswer,
    final String? correctAnswer,
    @Default(false) final bool? useDecoy,
    final int? score,
  }) = _RoundStatistics;

  factory RoundStatistics.fromJson(Map<String, dynamic> json) =>
      _$RoundStatisticsFromJson(json);
}
