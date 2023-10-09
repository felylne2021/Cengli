abstract class PreferenceManager {
  void saveString({required String key, required String value});

  void saveInt({required String key, required int value});

  void saveDouble({required String key, required double value});

  void saveBool({required String key, required bool value});

  String? getString({required String key});

  bool? getBool({required String key});

  int? getInt({required String key});

  double? getDouble({required String key});

  void removeValue({required String key});

  void clear();

  void reload();
}
