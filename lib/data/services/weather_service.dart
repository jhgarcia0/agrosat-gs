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
}
