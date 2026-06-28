import '../../../../core/enums/sync_status.dart';
import '../../../../utils/exports.dart';
import '../../domain/entities/explorer_filters.dart';
import '../../domain/entities/explorer_record_item.dart';
import '../../domain/enums/explorer_module_type.dart';
import '../explorer_module_labels.dart';

/// Single row in the Records Explorer results list.
class ExplorerRecordTile extends StatelessWidget {
  /// Creates [ExplorerRecordTile].
  const ExplorerRecordTile({
    required this.record,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    super.key,
  });

  /// Record to display.
  final ExplorerRecordItem record;

  /// View action.
  final VoidCallback onView;

  /// Edit action.
  final VoidCallback onEdit;

  /// Delete action.
  final VoidCallback onDelete;

  /// Share action.
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;
    final String moduleLabel =
        ExplorerModuleLabels.label(strings, record.moduleType);
    final String date = dateToString(
      record.recordDate,
      dateFormat: DateConstants.yearMonthDayFormat,
    );
    final String amount = record.amount == null
        ? '—'
        : record.amount!.toStringAsFixed(2);
    final bool canDelete =
        record.moduleType != ExplorerModuleType.calendarEvent;

    return Card(
      elevation: Dimens.elevation0,
      margin: const EdgeInsets.only(bottom: Dimens.space8),
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radius12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomTextLabelWidget(
                        label: record.name,
                        textAlign: TextAlign.start,
                        style: AppStyles.instance.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: Dimens.space4),
                      CustomTextLabelWidget(
                        label: date,
                        textAlign: TextAlign.start,
                        style: AppStyles.instance.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(moduleLabel),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: Dimens.space8),
            Wrap(
              spacing: Dimens.space12,
              runSpacing: Dimens.space4,
              children: <Widget>[
                _Meta(strings.amountKey, amount),
                _Meta(strings.recordsExplorerCategoryKey, record.category),
                _Meta(
                  strings.pendingSyncKey,
                  record.syncStatus.name,
                ),
              ],
            ),
            if (record.notes?.isNotEmpty ?? false) ...<Widget>[
              const SizedBox(height: Dimens.space8),
              CustomTextLabelWidget(
                label: record.notes!,
                textAlign: TextAlign.start,
                maxLines: Dimens.maxLines02,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.instance.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: Dimens.space8),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: onView,
                  child: Text(strings.recordsExplorerViewKey),
                ),
                TextButton(
                  onPressed: onEdit,
                  child: Text(strings.recordsExplorerEditKey),
                ),
                if (canDelete)
                  TextButton(
                    onPressed: onDelete,
                    child: Text(
                      strings.recordsExplorerDeleteKey,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                IconButton(
                  tooltip: strings.recordsExplorerShareKey,
                  onPressed: onShare,
                  icon: const Icon(Icons.share_outlined, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return CustomTextLabelWidget(
      label: '$label: $value',
      style: AppStyles.instance.textTheme.labelSmall,
    );
  }
}
