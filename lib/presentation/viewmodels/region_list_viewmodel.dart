import 'package:flutter/foundation.dart';
import '../../data/models/region.dart';
import '../../data/repositories/analysis_repository.dart';

class RegionListViewModel extends ChangeNotifier {
  final AnalysisRepository _repository;

  Set<String> _favorites = {};

  RegionListViewModel(this._repository) {
    _loadFavorites();
  }

  List<Region> get regions => Region.brazilianRegions;
  Set<String> get favorites => _favorites;

  bool isFavorite(String regionId) => _favorites.contains(regionId);

  Future<void> _loadFavorites() async {
    _favorites = await _repository.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(String regionId) async {
    await _repository.toggleFavorite(regionId);
    _favorites = await _repository.getFavorites();
    notifyListeners();
  }
}
