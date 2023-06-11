import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/data.dart';
import 'package:todo/models/category.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super(categries);

  void addCategory(Category category) {
    state = [...state, category];
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>(
        (ref) => CategoryNotifier());

class ActiveCategoryNotifier extends StateNotifier<Category?> {
  ActiveCategoryNotifier() : super(null);
  void setActiveCategory(Category? category) {
    state = category;
  }
}

final activeCategoryProvider =
    StateNotifierProvider<ActiveCategoryNotifier, Category?>(
        (ref) => ActiveCategoryNotifier());
