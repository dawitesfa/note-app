import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/picked_images_provider.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.images,
    required this.activeIndex,
  });
  final List<File> images;
  final int activeIndex;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late int currentPage;
  @override
  initState() {
    currentPage = widget.activeIndex;
    super.initState();
  }

  _onDeleteConfirm() => Navigator.of(context).pop();

  bool _onInteraction = false;
  final _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${currentPage + 1}/${widget.images.length}'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => ALertDialogu(
                  onRemoveImage: _onDeleteConfirm,
                  currentIndex: currentPage,
                  images: widget.images,
                ),
              );
            },
            icon: const Icon(
              Icons.delete_outline,
            ),
          )
        ],
      ),
      body: PageView(
        controller: PageController(
          initialPage: currentPage,
        ),
        onPageChanged: (value) {
          setState(() => currentPage = value);
        },
        physics: _onInteraction
            ? const NeverScrollableScrollPhysics()
            : const ScrollPhysics(),
        children: [
          ...widget.images.map(
            (img) => InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1,
              onInteractionEnd: (detail) {
                var scale = _transformationController.value.getMaxScaleOnAxis();
                setState(() {
                  _onInteraction = scale > 1;
                });
              },
              clipBehavior: Clip.none,
              child: Image.file(
                img,
                width: double.infinity,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ALertDialogu extends ConsumerWidget {
  const ALertDialogu(
      {super.key,
      required this.onRemoveImage,
      required this.currentIndex,
      required this.images});
  final void Function() onRemoveImage;
  final int currentIndex;
  final List<File> images;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Delete Image'),
      content: const Text('You are about to delete this awesome image!!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('I won\'t'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            final newImages =
                images.where((img) => img != images[currentIndex]).toList();
            ref.read(pickedImageProvider.notifier).fillFromItem(newImages);
            onRemoveImage();
          },
          child: const Text(
            "Just do it!",
          ),
        )
      ],
    );
  }
}
