import '../../../core/domain/entities/expense_entity.dart';
import '../widgets/admin_list_scaffold.dart';
import '../../../utils/exports.dart';

/// Web admin expense overview aggregating expense module use cases.
class ExpensesAdminPage extends StatefulWidget {
  /// Creates [ExpensesAdminPage].
  const ExpensesAdminPage({super.key});

  @override
  State<ExpensesAdminPage> createState() => _ExpensesAdminPageState();
}

class _ExpensesAdminPageState extends State<ExpensesAdminPage> {
  List<ExpenseEntity> _expenses = <ExpenseEntity>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
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

    if (!mounted) {
      return;
    }
    setState(() {
      _expenses = all;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminListScaffold(
      title: 'Expense Management',
      loading: _loading,
      empty: _expenses.isEmpty,
      child: ListView.separated(
        itemCount: _expenses.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          final ExpenseEntity expense = _expenses[index];
          return ListTile(
            title: Text(expense.title),
            subtitle: Text(
              '${expense.category.name} · ${expense.date.toIso8601String().split('T').first}',
            ),
            trailing: Text('₹${expense.amount}'),
          );
        },
      ),
    );
  }
}
