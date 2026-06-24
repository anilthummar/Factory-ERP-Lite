import '../../../../utils/exports.dart';

/// Pull-to-refresh list with empty-state support.
class CustomRefreshableListView extends StatelessWidget {
  /// Creates [CustomRefreshableListView].
  const CustomRefreshableListView({
    required this.isEmpty,
    required this.emptyView,
    required this.onRefresh,
    required this.itemCount,
    required this.itemBuilder,
    this.bottomPadding = Dimens.space80,
    super.key,
  });

  /// Whether the list is empty.
  final bool isEmpty;

  /// Widget shown when [isEmpty] is true.
  final Widget emptyView;

  /// Pull-to-refresh callback.
  final Future<void> Function() onRefresh;

  /// Number of list items.
  final int itemCount;

  /// List item builder.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Bottom padding for FAB clearance.
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverFillRemaining(
              hasScrollBody: false,
              child: emptyView,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: bottomPadding),
        itemCount: itemCount,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: Dimens.space12);
        },
        itemBuilder: itemBuilder,
      ),
    );
  }
}
