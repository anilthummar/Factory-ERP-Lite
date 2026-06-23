import '../../../utils/exports.dart';

/// Splash screen — routes to login or dashboard based on auth session.
@RoutePage()
class SplashPage extends StatelessWidget {
  /// Creates a splash page widget.
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (BuildContext ctx) => SplashBloc(),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (BuildContext context, SplashState state) {
          if (state.status == BaseStateStatus.success &&
              state.routeName != null) {
            unawaited(context.router.replaceNamed(state.routeName!));
          }
        },
        child: Scaffold(
          body: Center(
            child: Assets.png.icAppbarLogo.image(height: Dimens.size80),
          ),
        ),
      ),
    );
  }
}
