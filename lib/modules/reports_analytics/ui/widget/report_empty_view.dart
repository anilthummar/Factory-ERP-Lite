import '../../../../utils/exports.dart';

/// Empty state for report result areas.
class ReportEmptyView extends StatelessWidget {
  /// Creates [ReportEmptyView].
  const ReportEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return CustomEmptyStateWidget(
      icon: Icons.assessment_outlined,
      iconSize: Dimens.size48,
      title: strings.reportEmptyTitleKey,
      message: strings.reportEmptyMessageKey,
    );
  }
}
