import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/category.dart';
import 'package:todo/providers/active_tab_provider.dart';
import 'package:todo/providers/category_provider.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Category? selectedCategory = ref.watch(activeCategoryProvider);
    final categories = ref.watch(categoriesProvider);
    return Drawer(
      width: min(MediaQuery.of(context).size.width - 40, 320),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.only(left: 0),
              child: Center(
                child: ListTile(
                  selected: selectedCategory == null,
                  selectedTileColor: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(0.6),
                  onTap: () {
                    ref.read(activeTabProvider.notifier).setTabIndex(0);

                    Navigator.of(context).pop();
                    ref
                        .read(activeCategoryProvider.notifier)
                        .setActiveCategory(null);
                  },
                  leading: Icon(
                    Icons.book_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.75),
                  ),
                  title: Text(
                    'Notes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    'All notes...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            ...categories.map(
              (category) => ListTile(
                selected: selectedCategory != null &&
                    selectedCategory.id == category.id,
                selectedTileColor: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(0.6),
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(activeTabProvider.notifier).setTabIndex(0);
                  ref
                      .read(activeCategoryProvider.notifier)
                      .setActiveCategory(category);
                },
                leading: Icon(
                  Icons.bookmark,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
                ),
                title: Text(category.label),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
