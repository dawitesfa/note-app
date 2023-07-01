import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/picked_images_provider.dart';
import 'package:todo/providers/prefs_provider.dart';
import 'package:todo/providers/selected_color_provider.dart';
import 'package:todo/providers/selected_items_provider.dart';
import 'package:todo/screens/note_screen.dart';
import 'package:todo/widgets/stagerred_images.dart';

class NoteItem extends ConsumerWidget {
  const NoteItem({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(selectedItemsProvider);
    bool isSelecting = selectedNotes.isNotEmpty;
    bool isSelected = selectedNotes.contains(note);
    final images = note.imageUrls.length <= 6
        ? note.imageUrls
        : [...note.imageUrls].sublist(0, 6);
    return Container(
      decoration: BoxDecoration(
        color: note.color?.getColor(context),
        border: Border.all(
          width: isSelected ? 1.5 : 0.5,
          color: isSelected
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (isSelecting) {
            ref.read(selectedItemsProvider.notifier).addSelection(note);
          } else {
            ref.read(activeColorProvider.notifier).setColor(note.color);
            ref.read(pickedImageProvider.notifier).reset();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NoteScreen(note: note),
              ),
            );
          }
        },
        onLongPress: () {
          if (!isSelecting) {
            ref.read(selectedItemsProvider.notifier).addSelection(note);
          }
        },
        child: Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StagerredImageGrid(
                images: images,
                height: 250,
                clickable: false,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    note.title.isNotEmpty
                        ? Text(
                            note.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: 22,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.8),
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 4,
                    ),
                    note.note.isNotEmpty
                        ? Text(
                            note.note,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.8)),
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    note.category != null
                        ? InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              ref
                                  .read(prefsProvider.notifier)
                                  .savePref(activeCategory: note.category);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant
                                      .withOpacity(0.25),
                                ),
                              ),
                              child: Text(
                                note.category!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
