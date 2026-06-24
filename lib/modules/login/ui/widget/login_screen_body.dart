import '../../../../utils/exports.dart';

/// Figma login screen layout.
class LoginScreenBody extends StatelessWidget {
  /// Creates [LoginScreenBody].
  const LoginScreenBody({
    required this.appName,
    required this.googleLabel,
    required this.termsPrefix,
    required this.termsLabel,
    required this.termsAndLabel,
    required this.privacyLabel,
    required this.onGooglePressed,
    this.isGoogleLoading = false,
    this.onTermsPressed,
    this.onPrivacyPressed,
    super.key,
  });

  final String appName;
  final String googleLabel;
  final String termsPrefix;
  final String termsLabel;
  final String termsAndLabel;
  final String privacyLabel;
  final VoidCallback? onGooglePressed;
  final bool isGoogleLoading;
  final VoidCallback? onTermsPressed;
  final VoidCallback? onPrivacyPressed;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;

    return ColoredBox(
      color: colors.surface,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width:Dimens.space400,
                height: constraints.maxHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.space24,
                  ),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: Dimens.space72),

                      // ── App title — anchored near top ──
                      LoginAppTitle(title: appName),

                      const Spacer(),

                      // ── Logo ──
                      Assets.png.icAppbarLogo.image(
                        height: Dimens.size80,
                        width: Dimens.size80,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: Dimens.space72),

                      // ── Google sign-in button ──
                      LoginSocialButton(
                        label: googleLabel,
                        icon: const SvgGenImage(
                          'assets/svgs/ic_google_sign_in.svg',
                        ),
                        onPressed: onGooglePressed,
                        isLoading: isGoogleLoading,
                      ),

                      const Spacer(),                   // ← pushes footer to bottom

                      // ── Legal footer — anchored near bottom ──
                      LoginTermsFooter(
                        prefix: termsPrefix,
                        termsLabel: termsLabel,
                        andLabel: termsAndLabel,
                        privacyLabel: privacyLabel,
                        onTermsPressed: onTermsPressed,
                        onPrivacyPressed: onPrivacyPressed,
                      ),

                      const SizedBox(height: Dimens.space16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}