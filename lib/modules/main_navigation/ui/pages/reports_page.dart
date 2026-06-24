import '../../../../utils/exports.dart';

/// Reports tab placeholder.
class ReportsTabPage extends StatelessWidget {
  /// Creates [ReportsTabPage].
  const ReportsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: context.appString.navReportsKey,
          textAlign: TextAlign.start,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.space24),
          child: CustomTextLabelWidget(
            label: context.appString.reportsPageKey,
            style: AppStyles.instance.textTheme.bodyLarge?.copyWith(
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
