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
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
        errorMessage: null,
        routeName: null,
      ),
    );

    try {
      await _authRepository.signInWithGoogle();
      await SentryService.instance.captureEvent(
        'Login Successfully',
        tagKey: 'navigation',
        tagValue: 'login',
      );
      emit(
        state.copyWith(
          status: BaseStateStatus.success,
          routeName: AppPaths.dashboard,
        ),
      );
    } on AuthCancelledException {
      emit(state.copyWith(status: BaseStateStatus.initial));
    } on FirebaseAuthException catch (error) {
      emit(
        state.copyWith(
          status: BaseStateStatus.failure,
          errorMessage: _mapAuthError(error),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: BaseStateStatus.failure,
          errorMessage: 'Google sign-in failed. Please try again.',
        ),
      );
    }
  }

  String _mapAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
        return 'Google sign-in credentials are invalid. Check Firebase setup.';
      case 'operation-not-allowed':
        return 'Google sign-in is not enabled in Firebase Console.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      default:
        return error.message ?? 'Google sign-in failed. Please try again.';
    }
  }
}
