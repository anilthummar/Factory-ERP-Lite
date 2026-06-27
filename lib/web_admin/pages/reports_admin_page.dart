import '../../../utils/exports.dart';
import 'exports_admin_page.dart';

/// Reports hub with PDF/Excel actions and export download center.
class ReportsAdminPage extends StatefulWidget {
  /// Creates [ReportsAdminPage].
  const ReportsAdminPage({this.refreshTick = 0, super.key});

  /// Parent shell refresh counter.
  final int refreshTick;

  @override
  State<ReportsAdminPage> createState() => _ReportsAdminPageState();
}

class _ReportsAdminPageState extends State<ReportsAdminPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: TabBar(
            controller: _tabController,
            tabs: const <Tab>[
              Tab(text: 'Reports'),
              Tab(text: 'Export Center'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              _ReportsTab(key: ValueKey<int>(widget.refreshTick)),
              ExportsAdminPage(key: ValueKey<int>(widget.refreshTick)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Text(
          'Reports',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Generate PDF and Excel reports from live Hive data',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),
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
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(widget.icon),
        title: Text(widget.title),
        subtitle: _busy
            ? const Text('Exporting...')
            : const Text('PDF and Excel export available'),
        trailing: Wrap(
          spacing: 8,
          children: <Widget>[
            FilledButton.tonal(
              onPressed: _busy ? null : () => unawaited(_run(widget.onExportPdf)),
              child: const Text('PDF'),
            ),
            FilledButton.tonal(
              onPressed:
                  _busy ? null : () => unawaited(_run(widget.onExportExcel)),
              child: const Text('Excel'),
            ),
          ],
        ),
      ),
    );
  }
}
