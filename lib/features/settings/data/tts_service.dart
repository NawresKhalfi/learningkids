import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Wraps `flutter_tts` for the "lecture vocale" accessibility option
/// (EP13/US66) — reads a lesson's text aloud. Kept as a thin wrapper with
/// no logic of its own, same as `NotificationService` in EP11: this
/// plugin's platform channel has no test double, a documented, accepted
/// limitation (see `docs/FEATURES.md`).
class TtsService {
  TtsService({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;

  Future<void> setLanguage(String languageCode) => _tts.setLanguage(languageCode);

  Future<void> speak(String text, {required VoidCallback onComplete}) {
    _tts.setCompletionHandler(onComplete);
    return _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}

final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());
