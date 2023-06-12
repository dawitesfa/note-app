import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/grid_view_provider.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/widgets/note_item.dart';

class Notes extends ConsumerWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool largeDisplay = MediaQuery.of(context).size.width > 600;
    final isGrid = ref.watch(isGridViewProvider);
    final notes = ref.watch(filteredNotesProvider);
    final content = isGrid
        ? MasonryGridView.count(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemCount: notes.length,
            crossAxisCount: largeDisplay ? 3 : 2,
            crossAxisSpacing: 8,
            itemBuilder: (context, i) => ListContent(nt: notes[i], ref: ref),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemCount: notes.length,
            itemBuilder: (context, i) => ListContent(nt: notes[i], ref: ref),
          );

    return notes.isNotEmpty
        ? content
        : const Center(child: Text('Nothing to show for now...'));
  }
}

class ListContent extends StatelessWidget {
  const ListContent({super.key, required this.nt, required this.ref});
  final Note nt;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: Theme.of(context).colorScheme.error.withOpacity(0.5),
        ),
        child: const Center(
          child: Text('deleting...'),
        ),
      ),
      onDismissed: (direction) {
        int index = ref.watch(notesProvider).indexOf((nt));
        ref.read(notesProvider.notifier).removeNote(nt.id);
        ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Are you Sure, you want to delete this note?"),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                ref.read(notesProvider.notifier).saveNote(nt, index: index);
              },
            ),
          ),
        );
      },
      key: ValueKey(nt.id),
      child: NoteItem(
        note: nt,
      ),
    );
  }
}
