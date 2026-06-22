import '../../../utils/exports.dart';

/// Represents the state of the login process.
///
/// This state is used to manage the status of the login process,
/// including the current form state, login data, and navigation route.
class LoginState extends Equatable {
  /// The current status of the login process.
  final BaseStateStatus status;

  /// The local login data.
  final LoginLocal loginLocal;

  /// The name of the route to navigate to after login.
  final String? routeName;

  /// The form key for the login form.
  final GlobalKey<FormState> formKey;

  /// Creates a new instance of [LoginState].
  ///
  /// The [formKey] parameter is required.
  const LoginState({
    this.status = BaseStateStatus.initial,
    this.routeName,
    required this.formKey,
    this.loginLocal = const LoginLocal(),
  });

  /// Creates a copy of this state with the given fields replaced with new values.
  LoginState copyWith({
    BaseStateStatus? status,
    LoginLocal? loginLocal,
    bool? onChange,
    String? routeName,
  }) {
    return LoginState(
      status: status ?? this.status,
      routeName: routeName,
      loginLocal: loginLocal ?? this.loginLocal,
      formKey: formKey,
    );
  }

  @override
  List<dynamic> get props => <dynamic>[status, loginLocal, routeName];
}

