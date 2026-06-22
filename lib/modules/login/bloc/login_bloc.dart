import '../../../utils/exports.dart';

/// A BLoC that manages the state of the login process.
///
/// This bloc handles user authentication and login form interactions.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// Creates a [LoginBloc] instance.
  LoginBloc() : super(LoginState(formKey: GlobalKey<FormState>())) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  /// Handles redirection after successful login.
  Future<void> _handleRedirection(Emitter<LoginState> emit) async {
    if (SharedPref.instance.getBool(SharedPref.isLoggedInKey) == false) {
      await SharedPref.instance.setValue(SharedPref.isLoggedInKey, true);
      await SentryService.instance.captureEvent(
        "Login Successfully",
        tagKey: "navigation",
        tagValue: "login",
      );

      emit(state.copyWith(
        status: BaseStateStatus.success,
        routeName: AppPaths.dashboard,
      ));
    }
  }

  /// Handles changes to the email field.
  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      loginLocal: state.loginLocal.copyWith(email: event.email),
      status: BaseStateStatus.success,
    ));
  }

  /// Handles changes to the password field.
  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      loginLocal: state.loginLocal.copyWith(
        password: event.password,
      ),
      status: BaseStateStatus.success,
    ));
  }

  /// Validates the login form and processes login.
  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.formKey.currentState?.validate() ?? false) {
      /// Configure the scope for Sentry
      await SentryService.instance.configScope(
        sentryUserId: AppConstant.sentryUserId,
        sentryUserEmail: AppConstant.sentryUserEmail,
      );
      await _handleRedirection(emit);
    }
  }
}

