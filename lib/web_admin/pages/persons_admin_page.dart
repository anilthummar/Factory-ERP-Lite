import '../../../core/domain/entities/person_entity.dart';
import '../../../utils/exports.dart';
import '../navigation/admin_form_navigation.dart';
import '../widgets/admin_data_page.dart';

/// Web admin person management with searchable paginated [DataTable].
class PersonsAdminPage extends StatelessWidget {
  /// Creates [PersonsAdminPage].
  const PersonsAdminPage({this.refreshTick = 0, super.key});

  /// Parent shell refresh counter.
  final int refreshTick;

  @override
  Widget build(BuildContext context) {
    return AdminDataPage<PersonEntity>(
      title: 'Person Management',
      subtitle: 'Manage factory contacts and person records',
      refreshTick: refreshTick,
      addButtonLabel: 'Add Person',
      onAdd: () => AdminFormNavigation.openPersonForm(context),
      onEdit: (PersonEntity item) =>
          AdminFormNavigation.openPersonForm(context, person: item),
      columns: const <DataColumn>[
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Mobile')),
        DataColumn(label: Text('Address')),
        DataColumn(label: Text('Sync')),
      ],
      loadItems: () async {
        final ResponseHandler<List<PersonEntity>> result =
            await getIt<GetPersonsUseCase>()();
        if (result is OnSuccessResponse<List<PersonEntity>>) {
          return result.response;
        }
        return <PersonEntity>[];
      },
      itemKey: (PersonEntity item) => item.id,
      matchesSearch: (PersonEntity item, String query) {
        return item.name.toLowerCase().contains(query) ||
            item.mobile.toLowerCase().contains(query) ||
            (item.address ?? '').toLowerCase().contains(query);
      },
      onBulkDelete: (Set<String> ids) async {
        final DeletePersonUseCase delete = getIt<DeletePersonUseCase>();
        for (final String id in ids) {
          await delete(id);
        }
      },
      buildRow: (
        PersonEntity item,
        bool selected,
        ValueChanged<bool?> onSelect,
      ) {
        return DataRow(
          selected: selected,
          onSelectChanged: onSelect,
          cells: <DataCell>[
            DataCell(Text(item.name)),
            DataCell(Text(item.mobile)),
            DataCell(Text(item.address ?? '—')),
            DataCell(AdminSyncStatusChip(status: item.syncStatus.name)),
          ],
        );
      },
    );
  }
}
