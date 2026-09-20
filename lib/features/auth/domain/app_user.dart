/// The authenticated user, as far as the app's own features are concerned
/// (a thin projection of `firebase_auth`'s `User`, so the rest of the app
/// never depends on the Firebase SDK directly).
class AppUser {
  const AppUser({required this.uid, this.email, this.displayName});

  final String uid;
  final String? email;
  final String? displayName;
}
