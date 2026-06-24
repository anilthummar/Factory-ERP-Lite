import '../../expense/foundation/expense_module_bloc.dart';
import '../../expense/foundation/expense_module_config.dart';
import '../domain/usecases/material_purchase_use_cases.dart';

/// BLoC for material purchase expenses.
class MaterialPurchaseBloc extends ExpenseModuleBloc {
  /// Creates [MaterialPurchaseBloc].
  MaterialPurchaseBloc({
    required GetMaterialPurchasesUseCase getMaterialPurchasesUseCase,
    required AddMaterialPurchaseUseCase addMaterialPurchaseUseCase,
    required UpdateMaterialPurchaseUseCase updateMaterialPurchaseUseCase,
    required DeleteMaterialPurchaseUseCase deleteMaterialPurchaseUseCase,
    required SearchMaterialPurchasesUseCase searchMaterialPurchasesUseCase,
  }) : super(
          config: ExpenseModuleConfig.materialPurchase,
          getExpensesUseCase: getMaterialPurchasesUseCase,
          addExpenseUseCase: addMaterialPurchaseUseCase,
          updateExpenseUseCase: updateMaterialPurchaseUseCase,
          deleteExpenseUseCase: deleteMaterialPurchaseUseCase,
          searchExpensesUseCase: searchMaterialPurchasesUseCase,
        );
}
