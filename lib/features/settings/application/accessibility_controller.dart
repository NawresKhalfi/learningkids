import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_preferences.dart';
import '../domain/text_scale_option.dart';

class TextScaleController extends Notifier<TextScaleOption> {
  @override
  TextScaleOption build() => TextScaleOptionX.fromStorageKey(ref.read(localPreferencesProvider).textScaleOption);

  Future<void> setOption(TextScaleOption option) async {
    await ref.read(localPreferencesProvider).setTextScaleOption(option.name);
    state = option;
  }
}

final textScaleControllerProvider = NotifierProvider<TextScaleController, TextScaleOption>(TextScaleController.new);

final textScaleFactorProvider = Provider<double>((ref) => ref.watch(textScaleControllerProvider).factor);
