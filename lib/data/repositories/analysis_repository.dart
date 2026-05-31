import 'package:shared_preferences/shared_preferences.dart';
import '../models/analysis_result.dart';
import '../models/region.dart';
import '../services/weather_service.dart';

class AnalysisRepository {
  final WeatherService _weatherService;

  static const _cropRanges = {
    'Soja': {
      'tempMin': 20.0,
      'tempMax': 30.0,
      'precipMin': 30.0,
      'precipMax': 70.0,
      'moistMin': 0.25,
      'moistMax': 0.60,
    },
    'Milho': {
      'tempMin': 18.0,
      'tempMax': 32.0,
      'precipMin': 25.0,
      'precipMax': 65.0,
      'moistMin': 0.20,
      'moistMax': 0.55,
    },
    'Arroz': {
      'tempMin': 22.0,
      'tempMax': 35.0,
      'precipMin': 55.0,
      'precipMax': 120.0,
      'moistMin': 0.40,
      'moistMax': 0.80,
    },
    'Trigo': {
      'tempMin': 10.0,
      'tempMax': 22.0,
      'precipMin': 20.0,
      'precipMax': 45.0,
      'moistMin': 0.15,
      'moistMax': 0.40,
    },
    'Cana-de-açúcar': {
      'tempMin': 24.0,
      'tempMax': 35.0,
      'precipMin': 45.0,
      'precipMax': 100.0,
      'moistMin': 0.30,
      'moistMax': 0.70,
    },
  };

  AnalysisRepository(this._weatherService);

  Future<AnalysisResult> analyze(Region region) async {
    final data = await _weatherService.fetchWeatherData(
      latitude: region.latitude,
      longitude: region.longitude,
    );

    final avgTemp = _weatherService.parseAvgTemp(data);
    final precipitation = _weatherService.parseWeeklyPrecipitation(data);
    final moisture = _weatherService.parseSoilMoisture(data);

    final cropScores = <String, double>{};
    for (final entry in _cropRanges.entries) {
      cropScores[entry.key] =
          _calcScore(avgTemp, precipitation, moisture, entry.value);
    }

    return AnalysisResult(
      regionId: region.id,
      avgTemp: avgTemp,
      weeklyPrecipitation: precipitation,
      soilMoisture: moisture,
      cropScores: cropScores,
      date: DateTime.now(),
    );
  }

  double _calcScore(
    double temp,
    double precip,
    double moisture,
    Map<String, double> ranges,
  ) {
    final t = _rangeScore(temp, ranges['tempMin']!, ranges['tempMax']!);
    final p = _rangeScore(precip, ranges['precipMin']!, ranges['precipMax']!);
    final m = _rangeScore(moisture, ranges['moistMin']!, ranges['moistMax']!);
    return (t * 0.35 + p * 0.40 + m * 0.25) * 100;
  }

  double _rangeScore(double value, double min, double max) {
    if (value < min) {
      return ((min - value) / min > 1) ? 0 : 1 - (min - value) / min;
    }
    if (value > max) {
      return ((value - max) / max > 1) ? 0 : 1 - (value - max) / max;
    }
    return 1.0;
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
