import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/core/config/shared_preference.dart';

/// Thrown when the user cancels Google sign-in.
class AuthCancelledException implements Exception {
  /// Creates an [AuthCancelledException].
  const AuthCancelledException();
}

/// Contract for Firebase authentication (Google sign-in).
abstract class AuthRepository {
  /// Currently signed-in Firebase user, if any.
  User? get currentUser;

  /// Whether a Firebase session is active.
  bool get isLoggedIn;

  /// Signs in with Google and persists session flags in [SharedPref].
  Future<User> signInWithGoogle();

  /// Signs out from Firebase and clears local session prefs.
  Future<void> signOut();
}
