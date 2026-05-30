import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Map<String, dynamic>> fetchWeatherData({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'daily': 'temperature_2m_max,temperature_2m_min,precipitation_sum',
      'hourly': 'soil_moisture_0_to_1cm',
      'timezone': 'America/Sao_Paulo',
      'forecast_days': '7',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar dados: ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  double parseAvgTemp(Map<String, dynamic> data) {
    final daily = data['daily'] as Map<String, dynamic>;
    final maxList = (daily['temperature_2m_max'] as List)
        .map((e) => (e as num?)?.toDouble() ?? 0.0)
        .toList();
    final minList = (daily['temperature_2m_min'] as List)
        .map((e) => (e as num?)?.toDouble() ?? 0.0)
        .toList();
    final avg = (maxList.reduce((a, b) => a + b) / maxList.length +
            minList.reduce((a, b) => a + b) / minList.length) /
        2;
    return double.parse(avg.toStringAsFixed(1));
  }

  double parseWeeklyPrecipitation(Map<String, dynamic> data) {
    final daily = data['daily'] as Map<String, dynamic>;
    final precList = (daily['precipitation_sum'] as List)
        .map((e) => (e as num?)?.toDouble() ?? 0.0)
        .toList();
    return double.parse(
        precList.reduce((a, b) => a + b).toStringAsFixed(1));
  }

  double parseSoilMoisture(Map<String, dynamic> data) {
    final hourly = data['hourly'] as Map<String, dynamic>;
    final values = (hourly['soil_moisture_0_to_1cm'] as List)
        .map((e) => (e as num?)?.toDouble())
        .where((e) => e != null && e > 0)
        .cast<double>()
        .take(24)
        .toList();
    if (values.isEmpty) return 0.3;
    final avg = values.reduce((a, b) => a + b) / values.length;
    return double.parse(avg.toStringAsFixed(3));
  }
}
