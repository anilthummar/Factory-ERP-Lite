import '../../../../utils/exports.dart';

/// Calendar tab placeholder.
class CalendarTabPage extends StatelessWidget {
  /// Creates [CalendarTabPage].
  const CalendarTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: context.appString.navCalendarKey,
          textAlign: TextAlign.start,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.space24),
          child: CustomTextLabelWidget(
            label: context.appString.calendarPageKey,
            style: AppStyles.instance.textTheme.bodyLarge?.copyWith(
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
