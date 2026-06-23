import '../../../utils/exports.dart';

/// A bloc that manages splash routing based on auth state.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  /// Creates an instance of the [SplashBloc].
  SplashBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? getIt<AuthRepository>(),
        super(const SplashState()) {
    on<SplashStarted>(_onStarted);
    add(const SplashStarted());
  }

  final AuthRepository _authRepository;

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future<void>.delayed(
      const Duration(seconds: Dimens.duration3),
    );

    final String routeName = _authRepository.isLoggedIn
        ? AppPaths.dashboard
        : AppPaths.login;

    emit(
      state.copyWith(
        status: BaseStateStatus.success,
        routeName: routeName,
      ),
    );
  }
}
