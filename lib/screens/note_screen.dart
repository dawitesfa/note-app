import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/custom_color.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/providers/selected_color_provider.dart';
import 'package:todo/widgets/add_label.dart';
import 'package:todo/widgets/color_pick.dart';

// ignore: must_be_immutable
class NoteScreen extends ConsumerWidget {
  NoteScreen({
    super.key,
    required this.note,
  });
  final Note note;

  String importedTitle = '';
  String importedNote = '';

  void onDeleteConfirm(bool yes, WidgetRef ref, BuildContext context) {
    if (yes) {
      Navigator.of(context).pop();
      ref.read(notesProvider.notifier).removeNote(note.id);
    }
  }

  final _formKey = GlobalKey<FormState>();

  void _saveNote(WidgetRef ref, BuildContext context) {
    _formKey.currentState!.save();
    if (importedNote.trim().isNotEmpty || importedTitle.trim().isNotEmpty) {
      note.title = importedTitle;
      note.note = importedNote;
      note.editedDate = DateTime.now();
      ref.read(notesProvider.notifier).saveNote(note);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Empty note is discarded!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColor? selectedColor = ref.watch(activeColorProvider);
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () async {
        _saveNote(ref, context);
        return true;
      },
      child: Scaffold(
        backgroundColor: selectedColor?.getColor(context),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.pin_drop,
              ),
            ),
          ],
          backgroundColor: selectedColor?.getColor(context),
        ),
        bottomNavigationBar: BottomAppBar(
          color: selectedColor?.getColor(context),
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (ctx) => ColorPick(notes: [note]),
                        );
                      },
                      icon: const Icon(Icons.color_lens),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (ctx) => AddLabel(note: note),
                        );
                      },
                      icon: const Icon(Icons.label),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete'),
                            content: const Text(
                                'Are you sure you want to delete this item?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    onDeleteConfirm(false, ref, ctx);
                                  },
                                  child: const Text('cancel')),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  onDeleteConfirm(true, ref, ctx);
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
              ),
              Text('edited: ${note.formattedDate}')
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 8, 8, keyboardHeight + 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: note.title,
                  onSaved: (value) {
                    importedTitle = value!;
                  },
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 20,
                      ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Title.',
                  ),
                ),
                TextFormField(
                  initialValue: note.note,
                  onSaved: (value) {
                    importedNote = value!;
                  },
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontSize: 14),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your note here.',
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
