import '../../../../utils/exports.dart';

/// Full status history screen (UI only).
@RoutePage()
class FactoryStatusHistoryPage extends StatelessWidget {
  /// Creates [FactoryStatusHistoryPage].
  const FactoryStatusHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;
    const List<FactoryStatusHistoryData> history =
        <FactoryStatusHistoryData>[];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.statusHistoryKey,
          textAlign: TextAlign.start,
        ),
      ),
      body: CustomResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.padding16),
          child: history.isEmpty
              ? const FactoryStatusHistoryEmptyView()
              : const FactoryStatusHistoryTimeline(history: history),
        ),
      ),
    );
  }
}
