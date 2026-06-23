import '../../../../utils/exports.dart';

/// Login screen with Google Sign-In.
class LoginForm extends BaseResponsiveView {
  /// Creates a login form widget.
  const LoginForm({super.key});

  @override
  Widget buildTabletWidget(BuildContext context) => _loginView(context);

  @override
  Widget buildDesktopWidget(BuildContext context) => _loginView(context);

  @override
  Widget buildMobileWidget(BuildContext context) => _loginView(context);

  Widget _loginView(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state.status == BaseStateStatus.success && state.routeName != null) {
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
        final bool isLoading = state.status == BaseStateStatus.loading;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.space24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Assets.png.icAppbarLogo.image(height: Dimens.size80),
                  const SizedBox(height: Dimens.space24),
                  CustomTextLabelWidget(
                    label: context.appString.appNameKey,
                    style: AppStyles.instance.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Dimens.space8),
                  CustomTextLabelWidget(
                    label: context.appString.signInSubtitleKey,
                    style: AppStyles.instance.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Dimens.space32),
                  CustomButtonWidget(
                    text: isLoading
                        ? context.appString.loadingKey
                        : context.appString.signInWithGoogleKey,
                    isDisable: isLoading,
                    onClick: () {
                      context
                          .read<LoginBloc>()
                          .add(const LoginGoogleSignInRequested());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
