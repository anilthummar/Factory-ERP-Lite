import '../../../../utils/exports.dart';

/// PDF and Excel export action buttons (UI placeholders).
class ReportExportActions extends StatelessWidget {
  /// Creates [ReportExportActions].
  const ReportExportActions({
    this.onExportPdf,
    this.onExportExcel,
    super.key,
  });

  /// Export PDF callback placeholder.
  final VoidCallback? onExportPdf;

  /// Export Excel callback placeholder.
  final VoidCallback? onExportExcel;

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onExportPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: CustomTextLabelWidget(
              label: strings.exportPdfKey,
              style: AppStyles.instance.textTheme.labelMedium,
            ),
          ),
        ),
        const SizedBox(width: Dimens.space12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onExportExcel,
            icon: Icon(
              Icons.table_chart_outlined,
              color: colorScheme.primary,
            ),
            label: CustomTextLabelWidget(
              label: strings.exportExcelKey,
              style: AppStyles.instance.textTheme.labelMedium,
            ),
          ),
        ),
      ],
    );
  }
}
