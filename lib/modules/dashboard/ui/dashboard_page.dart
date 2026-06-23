import '../../../../utils/exports.dart';

/// ERP dashboard home — shown after successful Google sign-in.
@RoutePage()
class DashboardPage extends BaseResponsiveView {
  /// The constructor for [DashboardPage].
  const DashboardPage({super.key});

  Widget _buildView(BuildContext context) {
    final User? user = getIt<AuthRepository>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: context.appString.dashboardPageKey,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => _signOut(context),
            child: CustomTextLabelWidget(
              label: context.appString.signOutKey,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTextLabelWidget(
              label: context.appString.welcomeDashboardKey,
              style: AppStyles.instance.textTheme.headlineMedium,
            ),
            const SizedBox(height: Dimens.space8),
            CustomTextLabelWidget(
              label: user?.displayName ?? user?.email ?? '',
              style: AppStyles.instance.textTheme.bodyMedium,
            ),
            const SizedBox(height: Dimens.space24),
            CustomTextLabelWidget(
              label: context.appString.dashboardModulesHintKey,
              style: AppStyles.instance.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await getIt<AuthRepository>().signOut();
    if (context.mounted) {
      unawaited(context.router.replaceNamed(AppPaths.login));
    }
  }

  @override
  Widget buildDesktopWidget(BuildContext context) => _buildView(context);

  @override
  Widget buildMobileWidget(BuildContext context) => _buildView(context);

  @override
  Widget buildTabletWidget(BuildContext context) => _buildView(context);
}
