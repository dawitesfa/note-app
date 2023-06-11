import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/data.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/category_provider.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super(notes);

  void saveNote(Note note, {int? index}) {
    if (index == null) {
      if (!state.contains(note)) {
        state = [...state, note];
      } else {
        editNote(note);
      }
    } else {
      var newState = [...state];
      newState.insert(index, note);
      state = newState;
    }
  }

  void editNote(Note note) {
    final newNotes = [...state];
    final oldNote = newNotes.where((n) => n.id == note.id).toList()[0];
    final currentIndex = newNotes.indexOf(oldNote);
    newNotes[currentIndex] = note;
    state = newNotes;
  }

  void removeNote(String id) {
    final newNotes = state.where((note) => note.id != id).toList();
    state = newNotes;
  }
}

final notesProvider =
    StateNotifierProvider<NotesNotifier, List<Note>>((ref) => NotesNotifier());

final filteredNotesProvider = Provider(
  (ref) {
    var allNotes = ref.watch(notesProvider);
    var activeCategory = ref.watch(activeCategoryProvider);
    if (activeCategory == null) return allNotes;
    return allNotes
        .where((note) => note.category?.id == activeCategory.id)
        .toList();
  },
);
