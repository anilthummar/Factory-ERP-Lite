import '../../../utils/exports.dart';

/// A BLoC that manages Google sign-in via Firebase Auth.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// Creates a [LoginBloc] instance.
  LoginBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? getIt<AuthRepository>(),
        super(const LoginState()) {
    on<LoginGoogleSignInRequested>(_onGoogleSignInRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onGoogleSignInRequested(
    LoginGoogleSignInRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(
      status: BaseStateStatus.loading,
      errorMessage: null,
      routeName: null,
    ));

    try {
      await _authRepository.signInWithGoogle();
      await SentryService.instance.captureEvent(
        'Login Successfully',
        tagKey: 'navigation',
        tagValue: 'login',
      );
      emit(state.copyWith(
        status: BaseStateStatus.success,
        routeName: AppPaths.dashboard,
      ));
    } on AuthCancelledException {
      emit(state.copyWith(status: BaseStateStatus.initial));
    } on Exception catch (error) {
      emit(state.copyWith(
        status: BaseStateStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
