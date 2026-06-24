import '../../../../utils/exports.dart';

/// Route entry for the Figma login screen with Google Sign-In.
@RoutePage()
class LoginPage extends StatelessWidget {
  /// Creates [LoginPage].
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext ctx) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) {
          if (state.status == BaseStateStatus.success &&
              state.routeName != null) {
            unawaited(context.router.replaceNamed(state.routeName!));
          }
          if (state.status == BaseStateStatus.failure &&
              state.errorMessage != null) {
            context.showAppSnackBar(state.errorMessage!);
          }
        },
        listenWhen: (LoginState previous, LoginState current) =>
            (current.status == BaseStateStatus.success &&
                current.routeName != null) ||
            (current.status == BaseStateStatus.failure &&
                current.errorMessage != null),
        builder: (BuildContext context, LoginState state) {
          final bool isGoogleLoading =
              state.status == BaseStateStatus.loading;

          return LoginScreenBody(
            appName: context.appString.appNameKey,
            googleLabel: context.appString.continueWithGoogleKey,
            termsPrefix: context.appString.termsAgreementPrefixKey,
            termsLabel: context.appString.termsOfServiceKey,
            termsAndLabel: context.appString.termsAndKey,
            privacyLabel: context.appString.privacyPolicyKey,
            isGoogleLoading: isGoogleLoading,
            onGooglePressed: isGoogleLoading
                ? null
                : () {
                    context
                        .read<LoginBloc>()
                        .add(const LoginGoogleSignInRequested());
                  },
          );
        },
      ),
    );
  }
}
