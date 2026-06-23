import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../app/core/config/shared_preference.dart';
import '../../../service/firebase/firebase_service.dart';
import '../../../service/sentry/sentry_service.dart';
import 'auth_repository.dart';

/// Firebase Auth + Google Sign-In implementation.
class AuthRepositoryImpl implements AuthRepository {
  /// Creates [AuthRepositoryImpl].
  AuthRepositoryImpl({
    required FirebaseService firebaseService,
    required GoogleSignIn googleSignIn,
  })  : _firebaseService = firebaseService,
        _googleSignIn = googleSignIn;

  final FirebaseService _firebaseService;
  final GoogleSignIn _googleSignIn;

  FirebaseAuth get _auth => _firebaseService.auth;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  bool get isLoggedIn => _auth.currentUser != null;

  @override
  Future<User> signInWithGoogle() async {
    final UserCredential credential = kIsWeb
        ? await _auth.signInWithPopup(GoogleAuthProvider())
        : await _signInWithGoogleMobile();

    final User? user = credential.user;
    if (user == null) {
      throw const AuthCancelledException();
    }

    await _persistSession(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
    await SharedPref.instance.setValue(SharedPref.isLoggedInKey, false);
    await SharedPref.instance.remove(SharedPref.userIdKey);
  }

  Future<UserCredential> _signInWithGoogleMobile() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthCancelledException();
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  Future<void> _persistSession(User user) async {
    await SharedPref.instance.setValue(SharedPref.isLoggedInKey, true);
    await SharedPref.instance.setValue(SharedPref.userIdKey, user.uid);
    await SentryService.instance.configScope(
      sentryUserId: user.uid,
      sentryUserEmail: user.email,
    );
  }
}
