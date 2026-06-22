import '../../../utils/exports.dart';

/// A page widget for displaying the splash screen.
///
/// This widget initializes the splash bloc and listens for state changes
/// to navigate to the login page upon success.
@RoutePage()
class SplashPage extends StatelessWidget {
  /// Creates a splash page widget.
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (BuildContext ctx) => SplashBloc(),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (BuildContext context, SplashState state) async {
          if (state.status == BaseStateStatus.success) {
            unawaited(context.router.pushNamed(AppPaths.login));
          }
        },
        child: Assets.png.icAppbarLogo.image(),
      ),
    );
  }
}
