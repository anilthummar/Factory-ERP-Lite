import '../../../core/sync/sync_module_type.dart';
import '../../expense/foundation/expense_module_repository_impl.dart';
import '../datasource/material_purchase_local_data_source.dart';
import 'material_purchase_repository.dart';

/// Hive-backed [MaterialPurchaseRepository] implementation.
class MaterialPurchaseRepositoryImpl extends ExpenseModuleRepositoryImpl
    implements MaterialPurchaseRepository {
  /// Creates [MaterialPurchaseRepositoryImpl].
  MaterialPurchaseRepositoryImpl({
    required MaterialPurchaseLocalDataSource localDataSource,
    super.syncSupport,
  }) : super(
          localDataSource: localDataSource,
          syncModuleType: SyncModuleType.materialPurchases,
        );
}
