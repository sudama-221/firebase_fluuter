// 関数を入れたプロバイダー
import 'package:flutter_riverpod/flutter_riverpod.dart';

final LoadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void startLoading() {
    state = true;
  }

  void endLoading() {
    state = false;
  }
}
