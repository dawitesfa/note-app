import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/database/database_helper.dart';

class PrefNotifier extends StateNotifier<Map<String, Object?>> {
  PrefNotifier()
      : super({
          'isGrid': true,
          'activeCategory': null,
          'isFirstTime': true,
        });
  final dbHelper = const DatabaseHelper();
  void savePref({bool? isGrid, String? activeCategory, bool? firstTime}) {
    var newCategory = state['activeCategory'] as String?;
    if (activeCategory != null) {
      newCategory = activeCategory.isEmpty ? null : activeCategory;
    }

    state = {
      'isGrid': isGrid ?? state['isGrid'],
      'activeCategory': newCategory,
      'isFirstTime': firstTime ?? state['isFirstTime'],
    };
    dbHelper.savePrefs(
        state['isGrid'], state['activeCategory'] ?? '', state['isFirstTime']);
  }

  void loadPrefs() async {
    try {
      final prefs = await dbHelper.fetchPrefs();
      state = prefs;
    } catch (e) {
      dbHelper.addPrefs(
          state['isGrid'], state['activeCategory'] ?? '', state['isFirstTime']);
    }
  }
}

final prefsProvider = StateNotifierProvider<PrefNotifier, Map<String, Object?>>(
    (ref) => PrefNotifier());
