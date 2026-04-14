class KoanWithExplanation {
  final String koanText;
  final String technicalExplanation;
  final String uniqueCode;

  const KoanWithExplanation({
    required this.koanText,
    required this.technicalExplanation,
    required this.uniqueCode,
  });

  factory KoanWithExplanation.fromJson(Map<String, dynamic> json) {
    return KoanWithExplanation(
      koanText: json['koanText'] as String,
      technicalExplanation: json['technicalExplanation'] as String,
      uniqueCode: json['uniqueCode'] as String,
    );
  }
}
