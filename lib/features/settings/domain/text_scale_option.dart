/// A user-chosen global text-size multiplier (EP13/US66) — applied via a
/// `MediaQuery` override in `app.dart` so every screen scales together,
/// without each widget needing its own accessibility-aware styling.
enum TextScaleOption { small, normal, large, extraLarge }

extension TextScaleOptionX on TextScaleOption {
  double get factor => switch (this) {
    TextScaleOption.small => 0.85,
    TextScaleOption.normal => 1.0,
    TextScaleOption.large => 1.15,
    TextScaleOption.extraLarge => 1.3,
  };

  static TextScaleOption fromStorageKey(String key) =>
      TextScaleOption.values.firstWhere((option) => option.name == key, orElse: () => TextScaleOption.normal);
}
