import '../../../utils/exports.dart';

/// Represents the state of the login process.
class LoginState extends Equatable {
  /// The current status of the login process.
  final BaseStateStatus status;

  /// The name of the route to navigate to after login.
  final String? routeName;

  /// Error message when sign-in fails.
  final String? errorMessage;

  /// Creates a new instance of [LoginState].
  const LoginState({
    this.status = BaseStateStatus.initial,
    this.routeName,
    this.errorMessage,
  });

  /// Creates a copy of this state with the given fields replaced with new values.
  LoginState copyWith({
    BaseStateStatus? status,
    String? routeName,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      routeName: routeName,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        routeName,
        errorMessage,
      ];
}
