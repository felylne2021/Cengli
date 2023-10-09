import 'package:cengli/di/shared_preferences/preference_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManagerImplementation implements PreferenceManager {
  SharedPreferences _preferences;

  PreferenceManagerImplementation(this._preferences);

  @override
  void saveBool({required String key, required bool value}) {
    _preferences.setBool(key, value);
  }

  @override
  void saveDouble({required String key, required double value}) {
    _preferences.setDouble(key, value);
  }

  @override
  void saveInt({required String key, required int value}) {
    _preferences.setInt(key, value);
  }

  @override
  void saveString({required String key, required String value}) {
    _preferences.setString(key, value);
  }

  @override
  bool? getBool({required String key}) {
    bool? boolValue = _preferences.getBool(key);
    return boolValue;
  }

  @override
  double? getDouble({required String key}) {
    double? doubleValue = _preferences.getDouble(key);
    return doubleValue;
  }

  @override
  int? getInt({required String key}) {
    int? intValue = _preferences.getInt(key);
    return intValue;
  }

  @override
  String? getString({required String key}) {
    String? stringValue = _preferences.getString(key);
    return stringValue;
  }

  @override
  void reload() {
    _preferences.reload();
  }

  @override
  void clear() {
    _preferences.clear();
  }

  @override
  void removeValue({required String key}) {
    _preferences.remove(key);
  }
}
