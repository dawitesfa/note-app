import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/models/custom_color.dart';
import 'package:todo/models/note.dart';
import 'package:todo/widgets/add_label.dart';
import 'package:todo/widgets/color_pick.dart';
import 'package:todo/widgets/note_screen/image_picker.dart';

class ButtomAppBar extends StatelessWidget {
  const ButtomAppBar({
    super.key,
    required this.selectedColor,
    required this.note,
  });

  final CustomColor? selectedColor;
  final Note note;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: selectedColor?.getColor(context),
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const ImagePick(source: ImageSource.camera),
                const ImagePick(source: ImageSource.gallery),
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
              ],
            ),
          ),
          Text('edited: ${note.formattedDate}')
        ],
      ),
    );
  }
}
