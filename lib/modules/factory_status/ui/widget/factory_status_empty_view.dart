import '../../../../utils/exports.dart';

/// Empty state for status history lists.
class FactoryStatusHistoryEmptyView extends StatelessWidget {
  /// Creates [FactoryStatusHistoryEmptyView].
  const FactoryStatusHistoryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return CustomEmptyStateWidget(
      icon: Icons.history_outlined,
      iconSize: Dimens.size48,
      title: strings.factoryStatusHistoryEmptyTitleKey,
      message: strings.factoryStatusHistoryEmptyMessageKey,
    );
  }
}
