import '../../../utils/exports.dart';

/// Download center for PDF and Excel exports.
class ExportsAdminPage extends StatelessWidget {
  /// Creates [ExportsAdminPage].
  const ExportsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Text(
          'Export Center',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Download reports using the same export pipeline as mobile',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),
        const _ExportSection(
          title: 'PDF Exports',
          icon: Icons.picture_as_pdf_outlined,
          exports: <_ExportAction>[
            _ExportAction(
              label: 'Expense Report',
              run: _exportExpensePdf,
            ),
            _ExportAction(
              label: 'Labor Report',
              run: _exportLaborPdf,
            ),
            _ExportAction(
              label: 'Person Report',
              run: _exportPersonPdf,
            ),
            _ExportAction(
              label: 'Monthly Summary',
              run: _exportMonthlyPdf,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _ExportSection(
          title: 'Excel Exports',
          icon: Icons.table_chart_outlined,
          exports: <_ExportAction>[
            _ExportAction(
              label: 'Expense Report',
              run: _exportExpenseExcel,
            ),
            _ExportAction(
              label: 'Labor Report',
              run: _exportLaborExcel,
            ),
            _ExportAction(
              label: 'Person Report',
              run: _exportPersonExcel,
            ),
            _ExportAction(
              label: 'Monthly Summary',
              run: _exportMonthlyExcel,
            ),
          ],
        ),
      ],
    );
  }

  static Future<void> _exportExpensePdf() =>
      getIt<ExportExpenseReportPdfUseCase>()();

  static Future<void> _exportExpenseExcel() =>
      getIt<ExportExpenseReportExcelUseCase>()();

  static Future<void> _exportLaborPdf() =>
      getIt<ExportLaborReportPdfUseCase>()();

  static Future<void> _exportLaborExcel() =>
      getIt<ExportLaborReportExcelUseCase>()();

  static Future<void> _exportPersonPdf() =>
      getIt<ExportPersonReportPdfUseCase>()();

  static Future<void> _exportPersonExcel() =>
      getIt<ExportPersonReportExcelUseCase>()();

  static Future<void> _exportMonthlyPdf() =>
      getIt<ExportMonthlySummaryPdfUseCase>()();

  static Future<void> _exportMonthlyExcel() =>
      getIt<ExportMonthlySummaryExcelUseCase>()();
}

class _ExportAction {
  const _ExportAction({required this.label, required this.run});

  final String label;
  final Future<void> Function() run;
}

class _ExportSection extends StatelessWidget {
  const _ExportSection({
    required this.title,
    required this.icon,
    required this.exports,
  });

  final String title;
  final IconData icon;
  final List<_ExportAction> exports;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...exports.map(
              (_ExportAction action) => _ExportButton(
                label: action.label,
                onPressed: action.run,
              ),
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(widget.label),
        trailing: FilledButton(
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
          child: Text(_busy ? 'Exporting...' : 'Download'),
        ),
      ),
    );
  }
}
