import '../../../utils/exports.dart';

/// A bloc that manages the state of the splash screen.
///
/// This bloc handles redirection after the splash screen is displayed.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  /// Creates an instance of the [SplashBloc].
  SplashBloc() : super(const SplashState()) {
    on<SplashStarted>(_onStarted);
    add(const SplashStarted());
  }

  /// Handles redirection after the splash screen.
  Future<void> _onStarted(SplashStarted event, Emitter<SplashState> emit) async {
    await Future<dynamic>.delayed(const Duration(seconds: Dimens.duration3), () {
      emit(state.copyWith(status: BaseStateStatus.success));
    });
  }
}
