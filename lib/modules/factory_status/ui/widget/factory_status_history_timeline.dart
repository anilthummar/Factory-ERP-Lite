import '../../../../utils/exports.dart';

/// Vertical timeline of factory status changes.
class FactoryStatusHistoryTimeline extends StatelessWidget {
  /// Creates [FactoryStatusHistoryTimeline].
  const FactoryStatusHistoryTimeline({
    required this.history,
    super.key,
  });

  /// Status history entries, newest first.
  final List<FactoryStatusHistoryData> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const FactoryStatusHistoryEmptyView();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: Dimens.padding8),
      itemCount: history.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: Dimens.space4),
      itemBuilder: (BuildContext context, int index) {
        final FactoryStatusHistoryData entry = history[index];
        final bool isLast = index == history.length - 1;

        return _TimelineItem(
          entry: entry,
          showConnector: !isLast,
        );
      },
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.entry,
    required this.showConnector,
  });

  final FactoryStatusHistoryData entry;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    final String changedAtLabel = dateToString(
      entry.changedAt,
      dateFormat: DateConstants.dateTimeFormat,
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: Dimens.size28,
            child: Column(
              children: <Widget>[
                Container(
                  width: Dimens.size12,
                  height: Dimens.size12,
                  decoration: BoxDecoration(
                    color: entry.status.foregroundColor(colorScheme),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: entry.status.backgroundColor(colorScheme),
                    ),
                  ),
                ),
                if (showConnector)
                  Expanded(
                    child: Container(
                      width: Dimens.borderWidth1,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Dimens.space12),
          Expanded(
            child: Card(
              elevation: Dimens.elevation0,
              margin: const EdgeInsets.only(bottom: Dimens.padding12),
              color: colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radius12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimens.padding16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FactoryStatusBadge(status: entry.status),
                        ),
                        CustomTextLabelWidget(
                          label: changedAtLabel,
                          textAlign: TextAlign.end,
                          style:
                              AppStyles.instance.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (entry.notes != null && entry.notes!.isNotEmpty) ...<
                        Widget>[
                      const SizedBox(height: Dimens.space12),
                      CustomTextLabelWidget(
                        label: entry.notes!,
                        textAlign: TextAlign.start,
                        style: AppStyles.instance.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
