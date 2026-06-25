import '../../../core/domain/entities/labor_entity.dart';
import '../widgets/admin_list_scaffold.dart';
import '../../../utils/exports.dart';

/// Web admin labor list reusing [GetLaborUseCase].
class LaborAdminPage extends StatefulWidget {
  /// Creates [LaborAdminPage].
  const LaborAdminPage({super.key});

  @override
  State<LaborAdminPage> createState() => _LaborAdminPageState();
}

class _LaborAdminPageState extends State<LaborAdminPage> {
  List<LaborEntity> _labor = <LaborEntity>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final ResponseHandler<List<LaborEntity>> result =
        await getIt<GetLaborUseCase>()();
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
      if (result is OnSuccessResponse<List<LaborEntity>>) {
        _labor = result.response;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminListScaffold(
      title: 'Labor Management',
      loading: _loading,
      empty: _labor.isEmpty,
      child: ListView.separated(
        itemCount: _labor.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          final LaborEntity worker = _labor[index];
          return ListTile(
            title: Text(worker.name),
            subtitle: Text('${worker.skill} · ${worker.mobile}'),
            trailing: Text('₹${worker.dailyWage}'),
          );
        },
      ),
    );
  }
}
