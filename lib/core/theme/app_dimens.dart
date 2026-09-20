/// Spacing, radius and shadow-offset constants shared by the design system.
///
/// The visual language leans on a "neo-playful" offset shadow (a solid
/// darker duplicate of the shape, pushed down-right) rather than blurred
/// Material elevation — see `app_button.dart` for the widget that draws it.
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

abstract final class AppRadii {
  static const field = 16.0;
  static const button = 18.0;
  static const card = 26.0;
  static const chip = 14.0;
}

abstract final class AppShadowOffsets {
  static const button = 4.0;
  static const card = 5.0;
}
