import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveTabNotifier extends StateNotifier<int> {
  ActiveTabNotifier() : super(0);

  void setTabIndex(int i) {
    state = i;
  }
}

final activeTabProvider =
    StateNotifierProvider<ActiveTabNotifier, int>((ref) => ActiveTabNotifier());
