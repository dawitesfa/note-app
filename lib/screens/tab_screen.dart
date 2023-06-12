import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/active_tab_provider.dart';
import 'package:todo/providers/grid_view_provider.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/providers/selected_color_provider.dart';
import 'package:todo/providers/selected_items_provider.dart';
import 'package:todo/screens/note_screen.dart';
import 'package:todo/widgets/color_pick.dart';
import 'package:todo/widgets/main_drawer.dart';
import 'package:todo/widgets/notes.dart';
import 'package:todo/widgets/tasks.dart';

class TabScreen extends ConsumerWidget {
  const TabScreen({super.key});

  //This function is to open a note screen
  void openNote({
    Note? note,
    required context,
    required WidgetRef ref,
  }) {
    final targetNote =
        note ?? Note(title: '', note: '', editedDate: DateTime.now());
    ref.read(activeColorProvider.notifier).setColor(null);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NoteScreen(
          note: targetNote,
        ),
      ),
    );
  }

  //This function is to delete the selected note items
  //And if a user cancel the deletion it will restore the deleted notes to their respective indexez
  _deleteSelection(ref, context) {
    final selections = ref.watch(selectedItemsProvider);
    final notes = ref.watch(notesProvider);
    var deletedNotes = [...selections];
    var indexes = deletedNotes.map((note) => notes.indexOf(note)).toList();

    //This for loop statement will delete all the selcted notes
    for (final note in selections) {
      ref.read(notesProvider.notifier).removeNote(note.id);
    }

    //Deselection
    ref.read(selectedItemsProvider.notifier).deselect();

    //Shows warnning snackbar and option to undo
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Are you sure you want to delete these notes?'),
        action: SnackBarAction(
          label: 'Undo',
          //when the undo action pressed all the deleted notes will be restored/undo
          onPressed: () {
            for (var i = 0;
                i < indexes.length && i < deletedNotes.length;
                i++) {
              ref.read(notesProvider.notifier).saveNote(
                    deletedNotes[i],
                    index: indexes[i],
                  );
            }
          },
        ),
      ),
    );
  }

  // _deSelection(ref) {
  //   ref.read(selectedItemsProvider.notifier).deselect();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTabIndex = ref.watch(activeTabProvider);
    final bool isGrid = ref.watch(isGridViewProvider);
    final selectedNotes = ref.watch(selectedItemsProvider);
    final bool isSelecting = selectedNotes.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // activeTabIndex == 0 ? toolbarTitle : 'Tasks',
          isSelecting ? "" : 'Notes',
        ),
        automaticallyImplyLeading: !isSelecting,
        actions: isSelecting
            // This list of widgets will be shown when in selecting mode
            ? [
                TextButton.icon(
                  label: Text(
                    '${selectedNotes.length}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                  ),
                  onPressed: () {
                    ref.read(selectedItemsProvider.notifier).deselect();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ColorPick(notes: selectedNotes),
                    );
                    ref.read(selectedItemsProvider.notifier).deselect();
                  },
                  icon: const Icon(Icons.color_lens),
                ),
                IconButton(
                  onPressed: () {
                    _deleteSelection(ref, context);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ]
            // This list of widgets will be shown when in normal mode
            : [
                IconButton(
                  onPressed: () {
                    ref.read(isGridViewProvider.notifier).toggleIsGridView();
                  },
                  icon: Icon(
                    !isGrid
                        ? Icons.grid_view_outlined
                        : Icons.view_agenda_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () => openNote(context: context, ref: ref),
                  icon: const Icon(Icons.add),
                )
              ],
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        currentIndex: activeTabIndex,
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        onTap: (index) {
          ref.read(activeTabProvider.notifier).setTabIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Tasks',
          ),
        ],
      ),
      body: activeTabIndex == 0 ? const Notes() : const Tasks(),
    );
  }
}
