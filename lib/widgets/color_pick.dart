import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/data.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/providers/selected_color_provider.dart';

class ColorPick extends ConsumerWidget {
  const ColorPick({
    super.key,
    required this.palleteSize,
    required this.note,
  });

  final double palleteSize;
  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      height: palleteSize * 2 + 56,
      width: double.infinity,
      child: Column(
        children: [
          const Text('Pick a color...'),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...colors.map(
                  (clr) => InkWell(
                    borderRadius: BorderRadius.circular(palleteSize / 2),
                    onTap: () {
                      final targetClr = clr.id != '0' ? clr : null;
                      note.color = targetClr;
                      ref
                          .read(activeColorProvider.notifier)
                          .setColor(targetClr);
                      ref.read(notesProvider.notifier).saveNote(note);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      width: palleteSize,
                      height: palleteSize,
                      decoration: BoxDecoration(
                        color: clr.getColor(context),
                        borderRadius: BorderRadius.circular(palleteSize / 2),
                        border: Border.all(color: Colors.blue),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
