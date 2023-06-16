import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/database_helper.dart';
import 'package:todo/providers/notes_provider.dart';

class PinnedNotifier extends StateNotifier<List<String>> {
  final dbHelper = const DatabaseHelper();
  PinnedNotifier() : super([]);
  void togglePinnedNote(String id) {
    if (state.contains(id)) {
      dbHelper.removePin(id);
      state = state.where((item) => item != id).toList();
    } else {
      dbHelper.addPin(id);
      state = [...state, id];
    }
  }

  Future<void> loadPins() async {
    try {
      final pins = await dbHelper.fetchPins();
      state = pins;
    } catch (e) {
      // dbHelper.addPin(state)
    }
  }
}

final pinnedItemsProvider = StateNotifierProvider<PinnedNotifier, List<String>>(
    (ref) => PinnedNotifier());

final pinnedNotesProvider = Provider((ref) {
  final pinnedItems = ref.watch(pinnedItemsProvider);
  final categorizedNotes = ref.watch(filteredNotesProvider);
  return categorizedNotes
      .where((note) => pinnedItems.contains(note.id))
      .toList();
});
