import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/constants.dart';
import 'package:todo/data/data.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/notes_provider.dart';
import 'package:todo/providers/selected_color_provider.dart';

class ColorPick extends ConsumerWidget {
  const ColorPick({
    super.key,
    required this.notes,
  });

  final List<Note> notes;

  void colorizeNote(ref, clr) {
    final targetClr = clr.id != '0' ? clr : null;
    ref.read(activeColorProvider.notifier).setColor(targetClr);
    for (final note in notes) {
      note.color = targetClr;
      ref.read(notesProvider.notifier).saveNote(note);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeColor = ref.watch(activeColorProvider);
    return BottomSheet(
      backgroundColor: activeColor?.getColor(context).withOpacity(0.6) ??
          Theme.of(context).scaffoldBackgroundColor,
      onClosing: () {},
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        height: palletesize * 2 + 56,
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
                      borderRadius: BorderRadius.circular(palletesize / 2),
                      onTap: () {
                        colorizeNote(ref, clr);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        width: palletesize,
                        height: palletesize,
                        decoration: BoxDecoration(
                          color: clr.getColor(context),
                          borderRadius: BorderRadius.circular(palletesize / 2),
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
      ),
    );
  }
}
