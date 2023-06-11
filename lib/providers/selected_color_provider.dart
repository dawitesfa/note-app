import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/custom_color.dart';

class ActiveColorNotifier extends StateNotifier<CustomColor?> {
  ActiveColorNotifier() : super(null);

  void setColor(CustomColor? color) {
    state = color;
  }
}

final activeColorProvider =
    StateNotifierProvider<ActiveColorNotifier, CustomColor?>(
        (ref) => ActiveColorNotifier());
