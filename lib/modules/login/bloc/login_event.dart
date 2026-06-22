import '../../../utils/exports.dart';

/// Represents events for the login process.
///
/// These events are dispatched to the [LoginBloc] to handle
/// user interactions and form submission.
sealed class LoginEvent extends Equatable {
  /// Creates a new [LoginEvent].
  const LoginEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Event triggered when the email field changes.
class LoginEmailChanged extends LoginEvent {
  /// The updated email value.
  final String email;

  /// Creates a [LoginEmailChanged] event.
  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => <Object?>[email];
}

/// Event triggered when the password field changes.
class LoginPasswordChanged extends LoginEvent {
  /// The updated password value.
  final String password;

  /// Creates a [LoginPasswordChanged] event.
  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => <Object?>[password];
}

/// Event triggered when the login form is submitted.
class LoginSubmitted extends LoginEvent {
  /// Creates a [LoginSubmitted] event.
  const LoginSubmitted();
}

