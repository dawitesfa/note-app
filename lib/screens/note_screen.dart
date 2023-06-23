import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/custom_color.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/providers/picked_images_provider.dart';
import 'package:todo/providers/pinned_provider.dart';
import 'package:todo/providers/selected_color_provider.dart';
import 'package:todo/widgets/note_screen/buttom_appbar.dart';
import 'package:todo/widgets/stagerred_images.dart';

// ignore: must_be_immutable
class NoteScreen extends ConsumerWidget {
  NoteScreen({
    super.key,
    required this.note,
  });
  final Note note;

  String importedTitle = '';
  String importedNote = '';
  List<File> selectedImage = [];

  void onDeleteConfirm(bool yes, WidgetRef ref, BuildContext context) {
    if (yes) {
      Navigator.of(context).pop();
      ref.read(notesProvider.notifier).removeNote(note.id);
    }
  }

  final _formKey = GlobalKey<FormState>();

  void _saveNote(WidgetRef ref, BuildContext context) {
    _formKey.currentState!.save();
    if (importedNote.trim().isNotEmpty ||
        importedTitle.trim().isNotEmpty ||
        selectedImage.isNotEmpty) {
      if (note.title != importedTitle ||
          note.note != importedNote ||
          note.imageUrls != selectedImage) {
        note.editedDate = DateTime.now();
      }
      note.title = importedTitle;
      note.note = importedNote;
      note.imageUrls = selectedImage;
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
    final pinnedIds = ref.watch(pinnedItemsProvider);
    final isPinned = pinnedIds.contains(note.id);
    selectedImage = ref.watch(pickedImageProvider);
    if (selectedImage.isEmpty) {
      selectedImage = note.imageUrls;
      ref.read(pickedImageProvider.notifier).fillFromItem(note.imageUrls);
    }
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
              onPressed: () {
                ref
                    .read(pinnedItemsProvider.notifier)
                    .togglePinnedNote(note.id);
                note.editedDate = DateTime.now();
              },
              icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
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
          backgroundColor: selectedColor?.getColor(context),
        ),
        bottomNavigationBar:
            ButtomAppBar(selectedColor: selectedColor, note: note),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: keyboardHeight + 8),
          child: Column(
            children: [
              selectedImage.isEmpty
                  ? const SizedBox()
                  : StagerredImageGrid(
                      images: selectedImage,
                      height: 350,
                      clickable: true,
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: note.title,
                        minLines: 1,
                        maxLines: 2,
                        onSaved: (value) {
                          importedTitle = value!;
                        },
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
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
                            .copyWith(fontSize: 15, height: 1.3),
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
            ],
          ),
        ),
      ),
    );
  }
}
