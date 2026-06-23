import '../../../utils/exports.dart';

/// Represents events for the login process.
sealed class LoginEvent extends Equatable {
  /// Creates a new [LoginEvent].
  const LoginEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Event triggered when the user taps Google sign-in.
class LoginGoogleSignInRequested extends LoginEvent {
  /// Creates a [LoginGoogleSignInRequested] event.
  const LoginGoogleSignInRequested();
}
