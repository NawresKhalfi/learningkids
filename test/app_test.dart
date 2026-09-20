import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/app.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Boots the whole app shell (router, theme, localization) with fakes for
/// Firebase and local storage — the "does it even start" smoke test.
void main() {
  testWidgets('a signed-out user lands on the welcome screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = LocalPreferences(await SharedPreferences.getInstance());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            AuthRepository(firebaseAuth: MockFirebaseAuth()),
          ),
          localPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const LearningKidsApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
