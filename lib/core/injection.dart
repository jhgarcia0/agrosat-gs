import 'package:get_it/get_it.dart';
import '../data/services/weather_service.dart';
import '../data/repositories/analysis_repository.dart';
import '../presentation/viewmodels/region_list_viewmodel.dart';
import '../presentation/viewmodels/analysis_viewmodel.dart';

final getIt = GetIt.instance;

void setupInjection() {
  getIt.registerLazySingleton<WeatherService>(() => WeatherService());
  getIt.registerLazySingleton<AnalysisRepository>(
    () => AnalysisRepository(getIt<WeatherService>()),
  );
  getIt.registerFactory<RegionListViewModel>(
    () => RegionListViewModel(getIt<AnalysisRepository>()),
  );
  getIt.registerFactory<AnalysisViewModel>(
    () => AnalysisViewModel(getIt<AnalysisRepository>()),
  );
}
