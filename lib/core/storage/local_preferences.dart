import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin typed wrapper around [SharedPreferences].
///
/// Features must not read/write raw `shared_preferences` keys directly;
/// they add their own typed accessors here (or in their own local store if
/// the data is richer than a handful of primitives).
class LocalPreferences {
  LocalPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _kOnboardingCompleteKeyPrefix = 'onboarding_complete_';

  /// Onboarding is learner-specific: more than one child can use the same
  /// device, and completing it for one account must not skip it for another.
  bool hasCompletedOnboarding(String uid) =>
      _prefs.getBool('$_kOnboardingCompleteKeyPrefix$uid') ?? false;

  Future<void> setOnboardingCompleted(String uid, bool value) =>
      _prefs.setBool('$_kOnboardingCompleteKeyPrefix$uid', value);

  // Notification preferences (EP11/US57/US59). Kept device-local rather
  // than in the Firestore profile: notifications are inherently scheduled
  // on this device, and nothing server-side ever needs to read them.
  static const _kDailyReminderEnabledKey = 'daily_reminder_enabled';
  static const _kDailyReminderHourKey = 'daily_reminder_hour';
  static const _kDailyReminderMinuteKey = 'daily_reminder_minute';
  static const _kRewardNotificationsEnabledKey = 'reward_notifications_enabled';

  /// On by default (opt-out, like the leaderboard in EP08) at a
  /// reasonable after-school default time.
  bool get dailyReminderEnabled =>
      _prefs.getBool(_kDailyReminderEnabledKey) ?? true;

  Future<void> setDailyReminderEnabled(bool value) =>
      _prefs.setBool(_kDailyReminderEnabledKey, value);

  int get dailyReminderHour => _prefs.getInt(_kDailyReminderHourKey) ?? 18;

  int get dailyReminderMinute => _prefs.getInt(_kDailyReminderMinuteKey) ?? 0;

  Future<void> setDailyReminderTime(int hour, int minute) async {
    await _prefs.setInt(_kDailyReminderHourKey, hour);
    await _prefs.setInt(_kDailyReminderMinuteKey, minute);
  }

  bool get rewardNotificationsEnabled =>
      _prefs.getBool(_kRewardNotificationsEnabledKey) ?? true;

  Future<void> setRewardNotificationsEnabled(bool value) =>
      _prefs.setBool(_kRewardNotificationsEnabledKey, value);

  // EP13/US64/US66: language and text-size are device-local display
  // preferences, not learner data, so — like the notification settings
  // above — they live here rather than in the Firestore profile.
  static const _kAppLanguageKey = 'app_language';
  static const _kTextScaleKey = 'text_scale_option';

  /// `'system'`, `'fr'` or `'en'` — see `AppLanguage`.
  String get appLanguage => _prefs.getString(_kAppLanguageKey) ?? 'system';

  Future<void> setAppLanguage(String storageKey) =>
      _prefs.setString(_kAppLanguageKey, storageKey);

  /// See `TextScaleOption`.
  String get textScaleOption => _prefs.getString(_kTextScaleKey) ?? 'normal';

  Future<void> setTextScaleOption(String storageKey) =>
      _prefs.setString(_kTextScaleKey, storageKey);

  List<String> extraCodeLanguages(String scope) =>
      _prefs.getStringList('extra_code_languages_$scope') ?? const [];

  Future<void> setExtraCodeLanguages(String scope, List<String> languages) =>
      _prefs.setStringList('extra_code_languages_$scope', languages);
}

/// Overridden in `main.dart` with the real instance loaded before `runApp`.
final localPreferencesProvider = Provider<LocalPreferences>(
  (ref) => throw UnimplementedError('localPreferencesProvider not overridden'),
);
