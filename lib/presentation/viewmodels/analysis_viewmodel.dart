import 'package:flutter/foundation.dart';
import '../../data/models/analysis_result.dart';
import '../../data/models/region.dart';
import '../../data/repositories/analysis_repository.dart';

enum ViewState { idle, loading, success, error }

class AnalysisViewModel extends ChangeNotifier {
  final AnalysisRepository _repository;

  ViewState _state = ViewState.idle;
  AnalysisResult? _result;
  String? _errorMessage;

  AnalysisViewModel(this._repository);

  ViewState get state => _state;
  AnalysisResult? get result => _result;
  String? get errorMessage => _errorMessage;

  Future<void> analyze(Region region) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _result = await _repository.analyze(region);
      _state = ViewState.success;
    } catch (_) {
      _errorMessage = 'Falha ao buscar dados satelitais. Verifique sua conexão.';
      _state = ViewState.error;
    }

    notifyListeners();
  }
}
