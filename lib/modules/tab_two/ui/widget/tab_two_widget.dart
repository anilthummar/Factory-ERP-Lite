import '../../../../utils/exports.dart';

/// A widget that displays the tab two page.
class TabTwoWidget extends BaseResponsiveView {
  /// The constructor for [TabTwoWidget].
  const TabTwoWidget({super.key});

  @override
  Widget buildDesktopWidget(BuildContext context) {
    return _buildViews(context);
  }

  @override
  Widget buildMobileWidget(BuildContext context) {
    return _buildViews(context);
  }

  @override
  Widget buildTabletWidget(BuildContext context) {
    return _buildViews(context);
  }

  Widget _buildViews(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              unawaited(context.router.pushNamed(AppPaths.tabTwoDetail));
            },
            child: CustomTextLabelWidget(
                label: context.appString.detailPageWithOutBottomBarKey)),
        const SizedBox(
          height: Dimens.space10,
        ),
        CustomTextLabelWidget(label: context.appString.changeLanguageKey),
        const SizedBox(
          height: Dimens.space10,
        ),
        CustomButtonWidget(
            onClick: () {
              unawaited(context
                  .instance<LocaleBloc>()
                  .changeLanguage(AppConstant.en));
            },
            width: Dimens.size200,
            text: context.appString.englishKey),
        const SizedBox(
          height: Dimens.space10,
        ),
        CustomButtonWidget(
            onClick: () {
              unawaited(context
                  .instance<LocaleBloc>()
                  .changeLanguage(AppConstant.hi));
            },
            width: Dimens.size200,
            text: context.appString.hindiKey),
      ],
    );
  }
}
