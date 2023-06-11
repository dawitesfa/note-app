import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsGridNotifier extends StateNotifier<bool> {
  IsGridNotifier() : super(true);

  void toggleIsGridView() {
    state = !state;
  }
}

final isGridViewProvider =
    StateNotifierProvider<IsGridNotifier, bool>((ref) => IsGridNotifier());
