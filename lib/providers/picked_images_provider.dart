import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

class PickedImageNotifier extends StateNotifier<List<File>> {
  PickedImageNotifier() : super([]);

  void addPickedImage(File image) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');
    state = [copiedImage, ...state];
  }

  void reset() {
    state = [];
  }

  void fillFromItem(images) async {
    print('called');
    state = await images;
  }
}

final pickedImageProvider =
    StateNotifierProvider<PickedImageNotifier, List<File>>(
        (ref) => PickedImageNotifier());
