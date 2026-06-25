import '../../../core/domain/entities/dashboard_data.dart';
import '../../../utils/exports.dart';

/// Web admin dashboard using shared dashboard use case.
class DashboardAdminPage extends StatefulWidget {
  /// Creates [DashboardAdminPage].
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  DashboardData? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final DashboardData data =
          await getIt<GetDashboardDataUseCase>()();
      if (!mounted) {
        return;
      }
      setState(() {
        _data = data;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    final DashboardData data = _data!;

    return ListView(
      padding: const EdgeInsets.all(Dimens.padding16),
      children: <Widget>[
        Text(
          'Dashboard',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Dimens.space16),
        Wrap(
          spacing: Dimens.space16,
          runSpacing: Dimens.space16,
          children: <Widget>[
            _MetricCard(label: 'Persons', value: '${data.totalPersons}'),
            _MetricCard(label: 'Labor', value: '${data.totalLabor}'),
            _MetricCard(label: 'Expenses', value: '${data.totalExpenses}'),
            _MetricCard(
              label: 'Pending Sync',
              value: '${data.pendingSyncCount}',
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label),
              const SizedBox(height: Dimens.space8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
