import '../../../core/domain/entities/labor_entity.dart';
import '../../../utils/exports.dart';
import '../navigation/admin_form_navigation.dart';
import '../widgets/admin_data_page.dart';

/// Web admin labor management with searchable paginated [DataTable].
class LaborAdminPage extends StatelessWidget {
  /// Creates [LaborAdminPage].
  const LaborAdminPage({this.refreshTick = 0, super.key});

  /// Parent shell refresh counter.
  final int refreshTick;

  @override
  Widget build(BuildContext context) {
    return AdminDataPage<LaborEntity>(
      title: 'Labor Management',
      subtitle: 'Manage workers, skills, and daily wages',
      refreshTick: refreshTick,
      addButtonLabel: 'Add Labor',
      onAdd: () => AdminFormNavigation.openLaborForm(context),
      onEdit: (LaborEntity item) =>
          AdminFormNavigation.openLaborForm(context, labor: item),
      columns: const <DataColumn>[
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Skill')),
        DataColumn(label: Text('Mobile')),
        DataColumn(label: Text('Daily Wage')),
        DataColumn(label: Text('Sync')),
      ],
      loadItems: () async {
        final ResponseHandler<List<LaborEntity>> result =
            await getIt<GetLaborUseCase>()();
        if (result is OnSuccessResponse<List<LaborEntity>>) {
          return result.response;
        }
        return <LaborEntity>[];
      },
      itemKey: (LaborEntity item) => item.id,
      matchesSearch: (LaborEntity item, String query) {
        return item.name.toLowerCase().contains(query) ||
            item.skill.toLowerCase().contains(query) ||
            item.mobile.toLowerCase().contains(query);
      },
      onBulkDelete: (Set<String> ids) async {
        final DeleteLaborUseCase delete = getIt<DeleteLaborUseCase>();
        for (final String id in ids) {
          await delete(id);
        }
      },
      buildRow: (
        LaborEntity item,
        bool selected,
        ValueChanged<bool?> onSelect,
      ) {
        return DataRow(
          selected: selected,
          onSelectChanged: onSelect,
          cells: <DataCell>[
            DataCell(Text(item.name)),
            DataCell(Text(item.skill)),
            DataCell(Text(item.mobile)),
            DataCell(Text('₹${item.dailyWage}')),
            DataCell(AdminSyncStatusChip(status: item.syncStatus.name)),
          ],
        );
      },
    );
  }
}
