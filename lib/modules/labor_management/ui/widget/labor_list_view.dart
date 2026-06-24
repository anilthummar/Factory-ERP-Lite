import '../../../../utils/exports.dart';

/// Labor list with pull-to-refresh and empty state.
class LaborListView extends StatelessWidget {
  /// Creates [LaborListView].
  const LaborListView({
    required this.laborRecords,
    required this.onRefresh,
    super.key,
  });

  /// Labor records to display.
  final List<LaborCardData> laborRecords;

  /// Pull-to-refresh placeholder callback.
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return CustomRefreshableListView(
      isEmpty: laborRecords.isEmpty,
      onRefresh: onRefresh,
      emptyView: CustomEmptyStateWidget(
        icon: Icons.engineering_outlined,
        title: strings.laborEmptyTitleKey,
        message: strings.laborEmptyMessageKey,
      ),
      itemCount: laborRecords.length,
      itemBuilder: (BuildContext context, int index) {
        return LaborCard(labor: laborRecords[index]);
      },
    );
  }
}
