import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/database_helper.dart';

class CategoryNotifier extends StateNotifier<List<String>> {
  CategoryNotifier() : super([]);

  final dbHelper = const DatabaseHelper();

  void loadData() async {
    state = await dbHelper.fetchCategories();
  }

  void addCategory(String category) {
    if (state.contains(category)) {
      return;
    }
    state = [...state, category];
    dbHelper.addCategoryToDb(category);
  }

  void removeCategory(String category) {
    state = [...state].where((cat) => cat != category).toList();
    dbHelper.removeCategoryFromDb(category);
  }
}

final catagoriesProvider =
    StateNotifierProvider<CategoryNotifier, List<String>>(
        (ref) => CategoryNotifier());
