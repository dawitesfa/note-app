import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/note.dart';

class SelectedItemsNotifier extends StateNotifier<List<Note>> {
  SelectedItemsNotifier() : super([]);

  void addSelection(Note note) {
    if (state.contains(note)) {
      state = state.where((nt) => nt.id != note.id).toList();
    } else {
      state = [...state, note];
    }
  }

  void deselect() {
    state = [];
  }
}

final selectedItemsProvider =
    StateNotifierProvider<SelectedItemsNotifier, List<Note>>(
        (ref) => SelectedItemsNotifier());
