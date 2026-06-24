import '../../expense/foundation/expense_module_config.dart';
import '../../expense/foundation/expense_module_local_data_source_impl.dart';
import '../../../service/hive/hive_manager.dart';
import 'material_purchase_local_data_source.dart';

/// Hive implementation of [MaterialPurchaseLocalDataSource].
class MaterialPurchaseLocalDataSourceImpl
    extends ExpenseModuleLocalDataSourceImpl
    implements MaterialPurchaseLocalDataSource {
  /// Creates [MaterialPurchaseLocalDataSourceImpl].
  MaterialPurchaseLocalDataSourceImpl({HiveManager? hiveManager})
      : super(
          config: ExpenseModuleConfig.materialPurchase,
          hiveManager: hiveManager,
        );
}
