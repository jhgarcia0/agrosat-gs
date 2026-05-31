import 'package:shared_preferences/shared_preferences.dart';
import '../models/analysis_result.dart';
import '../models/region.dart';
import '../services/weather_service.dart';

class AnalysisRepository {
  final WeatherService _weatherService;

  AnalysisRepository(this._weatherService);

  Future<AnalysisResult> analyze(Region region) async {
    final data = await _weatherService.fetchWeatherData(
      latitude: region.latitude,
      longitude: region.longitude,
    );

    final avgTemp = _weatherService.parseAvgTemp(data);
    final precipitation = _weatherService.parseWeeklyPrecipitation(data);
    final moisture = _weatherService.parseSoilMoisture(data);

    return AnalysisResult(
      regionId: region.id,
      avgTemp: avgTemp,
      weeklyPrecipitation: precipitation,
      soilMoisture: moisture,
      cropScores: {},
      date: DateTime.now(),
    );
  }

  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites')?.toSet() ?? {};
  }

  Future<void> toggleFavorite(String regionId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites')?.toSet() ?? {};
    if (favorites.contains(regionId)) {
      favorites.remove(regionId);
    } else {
      favorites.add(regionId);
    }
    await prefs.setStringList('favorites', favorites.toList());
  }
}
