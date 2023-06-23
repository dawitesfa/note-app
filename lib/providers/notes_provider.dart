import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/database/database_helper.dart';
import 'package:todo/providers/prefs_provider.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  final DatabaseHelper dbHelper = const DatabaseHelper();

  Future<void> loadData() async {
    state = await dbHelper.fetchNotes();
  }

  void saveNote(Note note, {int? index}) async {
    if (index == null) {
      if (!state.contains(note)) {
        state = [...state, note];
        dbHelper.addNoteToDb(note);
      } else {
        editNote(note);
        dbHelper.updateNoteOnDb(note);
      }
    } else {
      dbHelper.addNoteToDb(note);
      var newState = [...state];
      if (index < state.length) {
        newState.insert(index, note);
      } else {
        newState.add(note);
      }
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

  void removeNote(String id) async {
    dbHelper.removeNoteFromDb(id);
    final newNotes = state.where((note) => note.id != id).toList();
    state = newNotes;
  }
}

final notesProvider =
    StateNotifierProvider<NotesNotifier, List<Note>>((ref) => NotesNotifier());

final filteredNotesProvider = Provider(
  (ref) {
    var allNotes = ref.watch(notesProvider);
    allNotes.sort((b, a) => a.editedDate.compareTo(b.editedDate));
    var activeCategory = ref.watch(prefsProvider)['activeCategory'];
    if (activeCategory == null) return allNotes;
    return allNotes.where((note) => note.category == activeCategory).toList();
  },
);
