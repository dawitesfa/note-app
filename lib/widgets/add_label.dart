import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/data.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/category_provider.dart';
import 'package:todo/providers/notes_provider.dart';

class AddLabel extends ConsumerWidget {
  const AddLabel({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var newLabel = note.category?.label;
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
                  initialValue: note.category?.label,
                  decoration: const InputDecoration(
                    hintText: 'New Label',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (note.category?.label == newLabel || newLabel!.isEmpty) {
                    return;
                  }
                  Navigator.of(context).pop();
                  final cat = Category(label: newLabel!);
                  ref.read(categoriesProvider.notifier).addCategory(cat);
                  note.category = cat;
                  ref.read(notesProvider.notifier).saveNote(note);
                },
                icon: const Icon(
                  Icons.add,
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ref.watch(categoriesProvider).length,
              itemBuilder: (ctx, i) => ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  note.category = categries[i];
                  ref.read(notesProvider.notifier).saveNote(note);
                },
                leading: const Icon(Icons.bookmark),
                title: Text(
                  ref.watch(categoriesProvider)[i].label,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
