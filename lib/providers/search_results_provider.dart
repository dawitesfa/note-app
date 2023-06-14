import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/notes_provider.dart';

class SearchQueryNotifier extends StateNotifier<String> {
  SearchQueryNotifier() : super('');

  void searchFor(String query) {
    state = query;
  }
}

final searchQueryProvider = StateNotifierProvider<SearchQueryNotifier, String>(
    (ref) => SearchQueryNotifier());

final searchResultProvider = Provider(
  (ref) {
    final allNotes = ref.watch(notesProvider);
    final query = ref.watch(searchQueryProvider);
    final result = [];
    for (final note in allNotes) {
      if (note.title.toLowerCase().contains(query.toLowerCase()) &&
          note.title.isNotEmpty) {
        result.add({
          'note': note,
          'text': note.title,
        });
      }
      if (note.note.toLowerCase().contains(query.toLowerCase()) &&
          note.note.isNotEmpty) {
        result.add(
          {
            'note': note,
            'text': note.note,
          },
        );
      }
    }
    return result;
  },
);
