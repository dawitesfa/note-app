import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/pinned_provider.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/widgets/note_item.dart';

class ListContent extends StatelessWidget {
  const ListContent({
    super.key,
    required this.nt,
    required this.ref,
    required this.i,
  });
  final Note nt;
  final WidgetRef ref;
  final int i;

  @override
  Widget build(BuildContext context) {
    final pinnedNotes = ref.watch(pinnedNotesProvider);
    final pinned = pinnedNotes.isNotEmpty;
    final noteIndex = pinnedNotes.length;
    return Column(
      children: [
        (i == 0 && pinned)
            ? Container(
                padding: const EdgeInsets.only(top: 8),
                width: double.infinity,
                child: Text(
                  'Pinned',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            : const SizedBox(),
        (i == noteIndex)
            ? Container(
                padding: const EdgeInsets.only(top: 8),
                width: double.infinity,
                child: Text(
                  'All Notes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            : const SizedBox(),
        Dismissible(
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              color: Theme.of(context).colorScheme.error.withOpacity(0.3),
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
                content:
                    const Text("Are you Sure, you want to delete this note?"),
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
        ),
      ],
    );
  }
}
