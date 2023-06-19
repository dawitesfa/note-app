import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/providers/picked_images_provider.dart';
import 'package:todo/providers/prefs_provider.dart';
import 'package:todo/providers/selected_color_provider.dart';
import 'package:todo/providers/selected_items_provider.dart';
import 'package:todo/screens/note_screen.dart';
import 'package:todo/screens/search_screen.dart';
import 'package:todo/widgets/color_pick.dart';
import 'package:todo/widgets/main_drawer.dart';
import 'package:todo/widgets/note_list.dart';

class TabScreen extends ConsumerWidget {
  const TabScreen({super.key});

  //This function is to open a note screen
  void openNote({
    required context,
    required WidgetRef ref,
  }) {
    final currentCategory =
        ref.watch(prefsProvider)['activeCategory'] as String?;
    ref.read(activeColorProvider.notifier).setColor(null);
    final note = Note(title: '', note: '', category: currentCategory);
    ref.read(pickedImageProvider.notifier).reset();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NoteScreen(
          note: note,
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
    final prefs = ref.watch(prefsProvider);
    final isGrid = prefs['isGrid'] as bool;
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
            ? getSelectingActions(selectedNotes, context, ref)
            // This list of widgets will be shown when in normal mode
            : [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const SearchScreen()));
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(prefsProvider.notifier).savePref(isGrid: !isGrid);
                  },
                  icon: Icon(
                    !isGrid
                        ? Icons.grid_view_outlined
                        : Icons.view_agenda_outlined,
                  ),
                ),
              ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNote(context: context, ref: ref),
        child: const Icon(Icons.add),
      ),
      drawer: const MainDrawer(),
      body: const Notes(),
    );
  }

  List<Widget> getSelectingActions(
    List<Note> selectedNotes,
    BuildContext context,
    WidgetRef ref,
  ) {
    return [
      TextButton.icon(
        label: Text(
          '${selectedNotes.length}',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondaryContainer,
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
    ];
  }
}
