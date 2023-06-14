import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/category_provider.dart';
import 'package:todo/providers/notes_provider.dart';

class AddLabel extends ConsumerWidget {
  const AddLabel({
    super.key,
    required this.note,
  });

  final Note note;

  _removeCategory(ref, String category) {
    ref.read(catagoriesProvider.notifier).removeCategory(category);
    final notes = ref.watch(notesProvider);
    for (final note in notes) {
      if (note.category == category) {
        note.category = null;
        ref.read(notesProvider.notifier).saveNote(note);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var newLabel = note.category;
    final categories = ref.watch(catagoriesProvider);
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                    newLabel = value;
                  },
                  initialValue: note.category,
                  decoration: const InputDecoration(
                    hintText: 'New Label',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (note.category == newLabel || newLabel!.isEmpty) {
                    return;
                  }
                  Navigator.of(context).pop();
                  final cat = newLabel;
                  note.category = cat;
                  ref.read(notesProvider.notifier).saveNote(note);
                  ref.read(catagoriesProvider.notifier).addCategory(cat!);
                },
                icon: const Icon(
                  Icons.add,
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (ctx, i) => ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  note.category = categories[i];
                  ref.read(notesProvider.notifier).saveNote(note);
                },
                leading: const Icon(Icons.bookmark),
                title: Text(
                  categories[i],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _removeCategory(ref, categories[i]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
