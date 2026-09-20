import 'package:flutter/foundation.dart';
import 'package:learningkids/features/settings/data/tts_service.dart';

/// A `TtsService` double that records calls instead of touching
/// `flutter_tts`'s platform channel — which, like `flutter_local_notifications`
/// elsewhere in this project, has no test double of its own (see
/// `docs/FEATURES.md`).
class FakeTtsService implements TtsService {
  String? lastLanguage;
  String? lastSpokenText;
  bool isSpeaking = false;
  VoidCallback? _pendingOnComplete;

  @override
  Future<void> setLanguage(String languageCode) async {
    lastLanguage = languageCode;
  }

  @override
  Future<void> speak(String text, {required VoidCallback onComplete}) async {
    lastSpokenText = text;
    isSpeaking = true;
    _pendingOnComplete = onComplete;
  }

  @override
  Future<void> stop() async {
    isSpeaking = false;
  }

  /// Test-only helper to simulate `flutter_tts` reaching the end of the
  /// utterance on its own, without a `stop()` call.
  void completeSpeaking() {
    isSpeaking = false;
    _pendingOnComplete?.call();
  }
}
