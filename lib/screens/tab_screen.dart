import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/active_tab_provider.dart';
import 'package:todo/providers/category_provider.dart';
import 'package:todo/providers/grid_view_provider.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/providers/selected_color_provider.dart';
import 'package:todo/providers/selected_items_provider.dart';
import 'package:todo/screens/note_screen.dart';
import 'package:todo/widgets/main_drawer.dart';
import 'package:todo/widgets/notes.dart';
import 'package:todo/widgets/tasks.dart';

class TabScreen extends ConsumerWidget {
  const TabScreen({super.key});

  void openNote({Note? note, required context, required WidgetRef ref}) {
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

  _deleteSelection(ref) {
    final selections = ref.watch(selectedItemsProvider);
    for (final note in selections) {
      ref.read(notesProvider.notifier).removeNote(note.id);
    }
    _deSelection(ref);
  }

  _deSelection(ref) {
    ref.read(selectedItemsProvider.notifier).deselect();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTabIndex = ref.watch(activeTabProvider);
    final bool isGrid = ref.watch(isGridViewProvider);
    var toolbarTitle = ref.watch(activeCategoryProvider)?.label ?? 'Notes';
    final selectedNotes = ref.watch(selectedItemsProvider);
    final bool isSelecting = selectedNotes.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            // activeTabIndex == 0 ? toolbarTitle : 'Tasks',
            isSelecting ? selectedNotes.length.toString() : 'Notes'),
        automaticallyImplyLeading: !isSelecting,
        actions: isSelecting
            ? [
                IconButton(
                    onPressed: () {
                      _deSelection(ref);
                    },
                    icon: Icon(Icons.close)),
                IconButton(
                    onPressed: () {
                      _deleteSelection(ref);
                    },
                    icon: Icon(Icons.delete))
              ]
            : [
                IconButton(
                  onPressed: () {
                    ref.read(isGridViewProvider.notifier).toggleIsGridView();
                  },
                  icon: Icon(
                    !isGrid ? Icons.grid_view : Icons.list,
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
            icon: Icon(
              Icons.note,
            ),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_box,
            ),
            label: 'Tasks',
          ),
        ],
      ),
      // bottomNavigationBar: CustomBNB(),
      body: activeTabIndex == 0 ? const Notes() : const Tasks(),
    );
  }
}
