import '../../../utils/exports.dart';

/// Web admin exports page reusing PDF and Excel export use cases.
class ExportsAdminPage extends StatefulWidget {
  /// Creates [ExportsAdminPage].
  const ExportsAdminPage({super.key});

  @override
  State<ExportsAdminPage> createState() => _ExportsAdminPageState();
}

class _ExportsAdminPageState extends State<ExportsAdminPage> {
  String? _status;
  bool _busy = false;

  Future<void> _exportExpensePdf() async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      await getIt<ExportExpenseReportPdfUseCase>()();
      setState(() => _status = 'Expense PDF export completed.');
    } on Object catch (error) {
      setState(() => _status = error.toString());
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _exportExpenseExcel() async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      await getIt<ExportExpenseReportExcelUseCase>()();
      setState(() => _status = 'Expense Excel export completed.');
    } on Object catch (error) {
      setState(() => _status = error.toString());
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Dimens.padding16),
      children: <Widget>[
        Text(
          'Exports',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Dimens.space16),
        FilledButton(
          onPressed: _busy ? null : _exportExpensePdf,
          child: const Text('Export Expense Report (PDF)'),
        ),
        const SizedBox(height: Dimens.space12),
        FilledButton(
          onPressed: _busy ? null : _exportExpenseExcel,
          child: const Text('Export Expense Report (Excel)'),
        ),
        if (_busy) ...<Widget>[
          const SizedBox(height: Dimens.space24),
          const Center(child: CircularProgressIndicator()),
        ],
        if (_status != null) ...<Widget>[
          const SizedBox(height: Dimens.space16),
          Text(_status!),
        ],
      ],
    );
  }
}
