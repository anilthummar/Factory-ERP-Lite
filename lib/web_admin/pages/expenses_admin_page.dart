import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../core/domain/enums/expense_category.dart';
import '../../../utils/exports.dart';
import '../navigation/admin_form_navigation.dart';
import '../widgets/admin_data_page.dart';

/// Web admin expense management (one-time + recurring tabs).
class ExpensesAdminPage extends StatefulWidget {
  /// Creates [ExpensesAdminPage].
  const ExpensesAdminPage({this.refreshTick = 0, super.key});

  /// Parent shell refresh counter.
  final int refreshTick;

  @override
  State<ExpensesAdminPage> createState() => _ExpensesAdminPageState();
}

class _ExpensesAdminPageState extends State<ExpensesAdminPage>
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
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: TabBar(
            controller: _tabController,
            tabs: const <Tab>[
              Tab(text: 'Expenses'),
              Tab(text: 'Recurring Expenses'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              _OneTimeExpensesTab(refreshTick: widget.refreshTick),
              _RecurringExpensesTab(refreshTick: widget.refreshTick),
            ],
          ),
        ),
      ],
    );
  }
}

class _OneTimeExpensesTab extends StatelessWidget {
  const _OneTimeExpensesTab({required this.refreshTick});

  final int refreshTick;

  static const List<String> _categoryFilters = <String>[
    'Material',
    'Truck',
    'Maintenance',
    'Electricity',
    'Miscellaneous',
  ];

  @override
  Widget build(BuildContext context) {
    return AdminDataPage<ExpenseEntity>(
      title: 'Expense Management',
      subtitle: 'All one-time factory expenses',
      refreshTick: refreshTick,
      addButtonLabel: 'Add Expense',
      onAdd: () => AdminFormNavigation.openExpenseForm(context),
      onEdit: (ExpenseEntity item) =>
          AdminFormNavigation.openExpenseForm(context, expense: item),
      filterChips: _categoryFilters,
      filterItem: (ExpenseEntity item, String? filter) {
        if (filter == null) {
          return true;
        }
        return _categoryLabel(item.category) == filter;
      },
      columns: const <DataColumn>[
        DataColumn(label: Text('Title')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Sync')),
      ],
      loadItems: _loadExpenses,
      itemKey: (ExpenseEntity item) => item.id,
      matchesSearch: (ExpenseEntity item, String query) {
        return item.title.toLowerCase().contains(query) ||
            item.category.name.toLowerCase().contains(query);
      },
      onBulkDelete: (Set<String> ids) async {
        final List<ExpenseEntity> all = await _loadExpenses();
        for (final ExpenseEntity expense in all) {
          if (!ids.contains(expense.id)) {
            continue;
          }
          await _deleteExpense(expense);
        }
      },
      buildRow: (
        ExpenseEntity item,
        bool selected,
        ValueChanged<bool?> onSelect,
      ) {
        return DataRow(
          selected: selected,
          onSelectChanged: onSelect,
          cells: <DataCell>[
            DataCell(Text(item.title)),
            DataCell(Text(_categoryLabel(item.category))),
            DataCell(Text(item.date.toIso8601String().split('T').first)),
            DataCell(Text('₹${item.amount}')),
            DataCell(AdminSyncStatusChip(status: item.syncStatus.name)),
          ],
        );
      },
    );
  }

  static Future<List<ExpenseEntity>> _loadExpenses() async {
    final List<ExpenseEntity> all = <ExpenseEntity>[];
    final List<ResponseHandler<List<ExpenseEntity>>> results =
        await Future.wait<ResponseHandler<List<ExpenseEntity>>>(
      <Future<ResponseHandler<List<ExpenseEntity>>>>[
        getIt<GetMaterialPurchasesUseCase>()(),
        getIt<GetTruckExpensesUseCase>()(),
        getIt<GetMaintenanceExpensesUseCase>()(),
        getIt<GetElectricityExpensesUseCase>()(),
        getIt<GetMiscellaneousExpensesUseCase>()(),
      ],
    );

    for (final ResponseHandler<List<ExpenseEntity>> result in results) {
      if (result is OnSuccessResponse<List<ExpenseEntity>>) {
        all.addAll(result.response);
      }
    }

    all.sort(
      (ExpenseEntity a, ExpenseEntity b) => b.date.compareTo(a.date),
    );
    return all;
  }

  static String _categoryLabel(ExpenseCategory category) {
    return switch (category) {
      ExpenseCategory.materialPurchase => 'Material',
      ExpenseCategory.truck => 'Truck',
      ExpenseCategory.maintenance => 'Maintenance',
      ExpenseCategory.electricity => 'Electricity',
      ExpenseCategory.miscellaneous => 'Miscellaneous',
    };
  }

  static Future<void> _deleteExpense(ExpenseEntity expense) async {
    switch (expense.category) {
      case ExpenseCategory.materialPurchase:
        await getIt<DeleteMaterialPurchaseUseCase>()(expense.id);
      case ExpenseCategory.truck:
        await getIt<DeleteTruckExpenseUseCase>()(expense.id);
      case ExpenseCategory.maintenance:
        await getIt<DeleteMaintenanceExpenseUseCase>()(expense.id);
      case ExpenseCategory.electricity:
        await getIt<DeleteElectricityExpenseUseCase>()(expense.id);
      case ExpenseCategory.miscellaneous:
        await getIt<DeleteMiscellaneousExpenseUseCase>()(expense.id);
    }
  }
}

class _RecurringExpensesTab extends StatelessWidget {
  const _RecurringExpensesTab({required this.refreshTick});

  final int refreshTick;

  @override
  Widget build(BuildContext context) {
    return AdminDataPage<RecurringExpenseEntity>(
      title: 'Recurring Expenses',
      subtitle: 'Scheduled recurring factory expenses',
      refreshTick: refreshTick,
      addButtonLabel: 'Add Recurring',
      onAdd: () => AdminFormNavigation.openRecurringExpenseForm(context),
      onEdit: (RecurringExpenseEntity item) =>
          AdminFormNavigation.openRecurringExpenseForm(context, expense: item),
      columns: const <DataColumn>[
        DataColumn(label: Text('Title')),
        DataColumn(label: Text('Frequency')),
        DataColumn(label: Text('Start')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Sync')),
      ],
      loadItems: () async {
        final ResponseHandler<List<RecurringExpenseEntity>> result =
            await getIt<GetRecurringExpensesUseCase>()();
        if (result is OnSuccessResponse<List<RecurringExpenseEntity>>) {
          return result.response;
        }
        return <RecurringExpenseEntity>[];
      },
      itemKey: (RecurringExpenseEntity item) => item.id,
      matchesSearch: (RecurringExpenseEntity item, String query) {
        return item.title.toLowerCase().contains(query) ||
            item.frequency.name.toLowerCase().contains(query);
      },
      onBulkDelete: (Set<String> ids) async {
        final DeleteRecurringExpenseUseCase delete =
            getIt<DeleteRecurringExpenseUseCase>();
        for (final String id in ids) {
          await delete(id);
        }
      },
      buildRow: (
        RecurringExpenseEntity item,
        bool selected,
        ValueChanged<bool?> onSelect,
      ) {
        return DataRow(
          selected: selected,
          onSelectChanged: onSelect,
          cells: <DataCell>[
            DataCell(Text(item.title)),
            DataCell(Text(item.frequency.name)),
            DataCell(Text(item.startDate.toIso8601String().split('T').first)),
            DataCell(Text('₹${item.amount}')),
            DataCell(AdminSyncStatusChip(status: item.syncStatus.name)),
          ],
        );
      },
    );
  }
}
