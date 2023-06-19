import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/providers/picked_images_provider.dart';

class ImagePick extends ConsumerWidget {
  const ImagePick({
    super.key,
    required this.source,
  });
  final ImageSource source;

  void _pickImage(ref) async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: source, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    final pickedImageFile = File(pickedImage.path);
    ref.read(pickedImageProvider.notifier).addPickedImage(pickedImageFile);
  }

  @override
  Widget build(BuildContext context, ref) {
    return IconButton(
      onPressed: () {
        _pickImage(ref);
      },
      icon: Icon(source == ImageSource.camera ? Icons.camera : Icons.image),
    );
  }
}
