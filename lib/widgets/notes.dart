import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/category_provider.dart';
import 'package:todo/providers/grid_view_provider.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/widgets/note_item.dart';

class Notes extends ConsumerStatefulWidget {
  const Notes({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NotesState();
  }
}

class _NotesState extends ConsumerState<Notes> {
  @override
  void initState() {
    ref.read(notesProvider.notifier).loadData();
    ref.read(catagoriesProvider.notifier).loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool largeDisplay = MediaQuery.of(context).size.width > 600;
    final isGrid = ref.watch(isGridViewProvider);
    final notes = ref.watch(filteredNotesProvider);
    if (notes.isEmpty) {
      return Center(
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
    }
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
    return FutureBuilder(
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : content,
    );
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
