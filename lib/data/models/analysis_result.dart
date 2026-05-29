class AnalysisResult {
  final String regionId;
  final double avgTemp;
  final double weeklyPrecipitation;
  final double soilMoisture;
  final Map<String, double> cropScores;
  final DateTime date;

  const AnalysisResult({
    required this.regionId,
    required this.avgTemp,
    required this.weeklyPrecipitation,
    required this.soilMoisture,
    required this.cropScores,
    required this.date,
  });

  double get overallScore {
    if (cropScores.isEmpty) return 0;
    return cropScores.values.reduce((a, b) => a + b) / cropScores.length;
  }
}
