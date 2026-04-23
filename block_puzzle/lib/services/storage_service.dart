import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _bestScoreKey = 'best_score';
  static const String _soundEnabledKey = 'sound_enabled';

  SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  int getBestScore() {
    return _prefs.getInt(_bestScoreKey) ?? 0;
  }

  Future<void> saveBestScore(int score) async {
    final currentBest = getBestScore();
    if (score > currentBest) {
      await _prefs.setInt(_bestScoreKey, score);
    }
  }

  bool getSoundEnabled() {
    return _prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundEnabledKey, enabled);
  }

  SharedPreferences get _prefs {
    final preferences = _preferences;
    if (preferences == null) {
      throw StateError('StorageService.init must be called before use.');
    }
    return preferences;
  }
}
