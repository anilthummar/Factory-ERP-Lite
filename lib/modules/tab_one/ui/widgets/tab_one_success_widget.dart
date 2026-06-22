import '../../../../utils/exports.dart';

/// A widget that displays the success view for Tab One.
///
/// This widget shows user details and navigation options for Tab One.
class TabOneSuccessWidget extends BaseResponsiveView {
  /// The constructor for [TabOneSuccessWidget].
  const TabOneSuccessWidget({super.key});

  @override
  Widget buildDesktopWidget(BuildContext context) {
    return _pageView(context);
  }

  @override
  Widget buildMobileWidget(BuildContext context) {
    return _pageView(context);
  }

  @override
  Widget buildTabletWidget(BuildContext context) {
    return _pageView(context);
  }

  /// Builds the page view for Tab One success.
  ///
  /// [ctx] is the build context.
  Widget _pageView(BuildContext ctx) {
    return BlocBuilder<TabOneBloc, TabOneState>(
      buildWhen: (TabOneState previous, TabOneState current) =>
          current.status == BaseStateStatus.success &&
          current.userDetailResponse != null,
      builder: (BuildContext context, TabOneState state) {
        return Visibility(
          visible: state.userDetailResponse != null,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      unawaited(
                          context.router.pushNamed(AppPaths.tabOneDetail));
                    },
                    child: CustomTextLabelWidget(
                        label: context.appString.detailPageWithBottomBarKey)),
                const SizedBox(
                  height: Dimens.size50,
                ),
                CustomTextLabelWidget(label: context.appString.appNameKey),
                const SizedBox(
                  height: Dimens.size12,
                ),
                CustomTextLabelWidget(
                    label:
                        "\\${context.appString.emailKey} :- \\${state.userDetailResponse?.data?.email} \\n \\${context.appString.nameKey} :- \\${state.userDetailResponse?.data?.firstName} \\${state.userDetailResponse?.data?.lastName}"),
              ]),
        );
      },
    );
  }
}
