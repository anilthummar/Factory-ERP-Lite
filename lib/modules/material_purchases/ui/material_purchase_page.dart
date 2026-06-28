import '../../../../utils/exports.dart';
import '../../expense/foundation/expense_module_bloc.dart';
import '../../expense/foundation/expense_module_list_page.dart';
import '../bloc/material_purchase_bloc.dart';

/// Material purchase expense list screen.
@RoutePage()
class MaterialPurchasePage extends StatelessWidget {
  /// Creates [MaterialPurchasePage].
  const MaterialPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    return BlocProvider<ExpenseModuleBloc>(
      create: (BuildContext context) => MaterialPurchaseBloc(
        getMaterialPurchasesUseCase: getIt<GetMaterialPurchasesUseCase>(),
        addMaterialPurchaseUseCase: getIt<AddMaterialPurchaseUseCase>(),
        updateMaterialPurchaseUseCase: getIt<UpdateMaterialPurchaseUseCase>(),
        deleteMaterialPurchaseUseCase: getIt<DeleteMaterialPurchaseUseCase>(),
        searchMaterialPurchasesUseCase: getIt<SearchMaterialPurchasesUseCase>(),
      ),
      child: ExpenseModuleListPage(
        pageTitle: strings.materialPurchaseKey,
      ),
    );
  }
}
