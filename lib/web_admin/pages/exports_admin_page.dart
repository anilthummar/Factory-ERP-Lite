import '../../../utils/exports.dart';

/// Web admin export center for all report formats.
class ExportsAdminPage extends StatelessWidget {
  /// Creates [ExportsAdminPage].
  const ExportsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Dimens.padding16),
      children: <Widget>[
        Text(
          'Export Center',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Dimens.space8),
        Text(
          'Download PDF and Excel reports using the same mobile export pipeline',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: Dimens.space16),
        _ExportButton(
          label: 'Expense Report — PDF',
          onPressed: () => getIt<ExportExpenseReportPdfUseCase>()(),
        ),
        _ExportButton(
          label: 'Expense Report — Excel',
          onPressed: () => getIt<ExportExpenseReportExcelUseCase>()(),
        ),
        _ExportButton(
          label: 'Labor Report — PDF',
          onPressed: () => getIt<ExportLaborReportPdfUseCase>()(),
        ),
        _ExportButton(
          label: 'Labor Report — Excel',
          onPressed: () => getIt<ExportLaborReportExcelUseCase>()(),
        ),
        _ExportButton(
          label: 'Person Report — PDF',
          onPressed: () => getIt<ExportPersonReportPdfUseCase>()(),
        ),
        _ExportButton(
          label: 'Person Report — Excel',
          onPressed: () => getIt<ExportPersonReportExcelUseCase>()(),
        ),
        _ExportButton(
          label: 'Monthly Summary — PDF',
          onPressed: () => getIt<ExportMonthlySummaryPdfUseCase>()(),
        ),
        _ExportButton(
          label: 'Monthly Summary — Excel',
          onPressed: () => getIt<ExportMonthlySummaryExcelUseCase>()(),
        ),
      ],
    );
  }
}

class _ExportButton extends StatefulWidget {
  const _ExportButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final Future<void> Function() onPressed;

  @override
  State<_ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<_ExportButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.space12),
      child: FilledButton(
        onPressed: _busy
            ? null
            : () async {
                setState(() => _busy = true);
                try {
                  await widget.onPressed();
                } finally {
                  if (mounted) {
                    setState(() => _busy = false);
                  }
                }
              },
        child: Text(_busy ? 'Exporting...' : widget.label),
      ),
    );
  }
}
