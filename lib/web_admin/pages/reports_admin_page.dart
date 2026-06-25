import '../../../utils/exports.dart';

/// Web admin reports hub with export actions.
class ReportsAdminPage extends StatelessWidget {
  /// Creates [ReportsAdminPage].
  const ReportsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Dimens.padding16),
      children: <Widget>[
        Text(
          'Reports',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Dimens.space8),
        Text(
          'Live reports from shared repositories and use cases',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: Dimens.space16),
        _ReportTile(
          icon: Icons.receipt_long_outlined,
          title: 'Expense Report',
          onExportPdf: () => getIt<ExportExpenseReportPdfUseCase>()(),
          onExportExcel: () => getIt<ExportExpenseReportExcelUseCase>()(),
        ),
        _ReportTile(
          icon: Icons.engineering_outlined,
          title: 'Labor Report',
          onExportPdf: () => getIt<ExportLaborReportPdfUseCase>()(),
          onExportExcel: () => getIt<ExportLaborReportExcelUseCase>()(),
        ),
        _ReportTile(
          icon: Icons.people_outline,
          title: 'Person Report',
          onExportPdf: () => getIt<ExportPersonReportPdfUseCase>()(),
          onExportExcel: () => getIt<ExportPersonReportExcelUseCase>()(),
        ),
        _ReportTile(
          icon: Icons.calendar_month_outlined,
          title: 'Monthly Summary',
          onExportPdf: () => getIt<ExportMonthlySummaryPdfUseCase>()(),
          onExportExcel: () => getIt<ExportMonthlySummaryExcelUseCase>()(),
        ),
      ],
    );
  }
}

class _ReportTile extends StatefulWidget {
  const _ReportTile({
    required this.icon,
    required this.title,
    required this.onExportPdf,
    required this.onExportExcel,
  });

  final IconData icon;
  final String title;
  final Future<void> Function() onExportPdf;
  final Future<void> Function() onExportExcel;

  @override
  State<_ReportTile> createState() => _ReportTileState();
}

class _ReportTileState extends State<_ReportTile> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(widget.icon),
        title: Text(widget.title),
        subtitle: _busy
            ? const Text('Exporting...')
            : const Text('PDF and Excel export available'),
        trailing: Wrap(
          spacing: Dimens.space8,
          children: <Widget>[
            TextButton(
              onPressed: _busy ? null : () => _run(widget.onExportPdf),
              child: const Text('PDF'),
            ),
            TextButton(
              onPressed: _busy ? null : () => _run(widget.onExportExcel),
              child: const Text('Excel'),
            ),
          ],
        ),
      ),
    );
  }
}
