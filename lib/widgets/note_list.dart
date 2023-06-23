import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/category_provider.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/providers/pinned_provider.dart';
import 'package:todo/providers/prefs_provider.dart';
import 'package:todo/widgets/gridview_with_title.dart';
import 'package:todo/widgets/list_content.dart';
import 'package:todo/widgets/listview_with_title.dart';

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
        notes.where((note) => !pinnedNotes.contains(note)).toList();
    return FutureBuilder(
      future: _initialState,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : getListHolder(
                  ref: ref,
                  pinnedNotes: pinnedNotes,
                  notes: allNotes,
                  context: context,
                ),
    );
  }
}

Widget getListHolder({
  required WidgetRef ref,
  required List<Note> pinnedNotes,
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
  if (pinnedNotes.isEmpty && notes.isEmpty) {
    return content;
  }
  if (isGrid) {
    content = Column(
      children: [
        pinnedNotes.isEmpty
            ? const SizedBox()
            : GridViewWithTitle(
                count: pinnedNotes.length,
                title: 'Pinned Notes',
                colNum: largeDisplay ? 3 : 2,
                itemBuild: (context, i) => ListContent(
                  nt: pinnedNotes[i],
                  ref: ref,
                  i: i,
                ),
              ),
        notes.isEmpty
            ? const SizedBox()
            : GridViewWithTitle(
                count: notes.length,
                title: 'Other Notes',
                colNum: largeDisplay ? 3 : 2,
                itemBuild: (context, i) => ListContent(
                  nt: notes[i],
                  ref: ref,
                  i: i,
                ),
              )
      ],
    );
  } else {
    content = Column(
      children: [
        pinnedNotes.isEmpty
            ? const SizedBox()
            : ListViewWithTitle(
                title: 'Pinned Notes',
                count: pinnedNotes.length,
                itemBuild: (context, i) =>
                    ListContent(nt: pinnedNotes[i], ref: ref, i: i),
              ),
        notes.isEmpty
            ? const SizedBox()
            : ListViewWithTitle(
                title: 'Other Notes',
                count: notes.length,
                itemBuild: (context, i) =>
                    ListContent(nt: notes[i], ref: ref, i: i),
              )
      ],
    );
  }
  return SingleChildScrollView(child: content);
}
