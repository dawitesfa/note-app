import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/category_provider.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/providers/pinned_provider.dart';
import 'package:todo/providers/prefs_provider.dart';
import 'package:todo/widgets/note_item.dart';

class Notes extends ConsumerStatefulWidget {
  const Notes({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NotesState();
  }
}

class _NotesState extends ConsumerState<Notes> {
  late Future<void> _initialState;
  @override
  void initState() {
    _initialState = ref.read(notesProvider.notifier).loadData();
    ref.read(pinnedItemsProvider.notifier).loadPins();
    ref.read(catagoriesProvider.notifier).loadData();
    ref.read(prefsProvider.notifier).loadPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(filteredNotesProvider);
    final pinnedNotes = ref.watch(pinnedNotesProvider);
    final allNotes =
        notes.where((element) => !pinnedNotes.contains(element)).toList();
    return FutureBuilder(
      future: _initialState,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : getListHolder(
                  ref: ref,
                  notes: [...pinnedNotes, ...allNotes],
                  context: context,
                ),
    );
  }
}

Widget getListHolder({
  required WidgetRef ref,
  required List<Note> notes,
  required BuildContext context,
}) {
  final bool largeDisplay = MediaQuery.of(context).size.width > 600;
  final isGrid = ref.watch(prefsProvider)['isGrid'] as bool;
  Widget content = Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'There is no item to show, please add Note or pick other label.',
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
  );
  if (notes.isNotEmpty) {
    if (isGrid) {
      content = MasonryGridView.count(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        itemCount: notes.length,
        crossAxisCount: largeDisplay ? 3 : 2,
        crossAxisSpacing: 8,
        itemBuilder: (context, i) => ListContent(nt: notes[i], ref: ref, i: i),
      );
    } else {
      content = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        itemCount: notes.length,
        itemBuilder: (context, i) => ListContent(nt: notes[i], ref: ref, i: i),
      );
    }
  }
  return content;
}

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
