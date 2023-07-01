import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/picked_images_provider.dart';
import 'package:todo/providers/prefs_provider.dart';
import 'package:todo/providers/selected_color_provider.dart';
import 'package:todo/screens/note_screen.dart';

class EmptyList extends ConsumerWidget {
  const EmptyList({super.key});

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

  @override
  build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          'assets/images/empty_list.png',
          width: 56,
          height: 56,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          'Ooops..! there is no content to show!',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                openNote(context: context, ref: ref);
              },
              child: const Text(
                'CLICK HERE!',
              ),
            ),
            Text(
              'to add notes',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 16),
            ),
          ],
        )
      ],
    );
  }
}
