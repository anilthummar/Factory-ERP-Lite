import '../../core/sync/sync_module_type.dart';
import '../firebase/firestore_collections.dart';
import '../hive/hive_box_names.dart';

/// Metadata for mapping a [SyncModuleType] to Hive and Firestore.
class SyncModuleDescriptor {
  /// Creates [SyncModuleDescriptor].
  const SyncModuleDescriptor({
    required this.module,
    required this.hiveBoxName,
    required this.firestoreCollection,
  });

  /// Syncable module identifier.
  final SyncModuleType module;

  /// Hive box that stores local records for this module.
  final String hiveBoxName;

  /// Firestore collection path for remote sync.
  final String firestoreCollection;
}

/// Returns descriptor metadata for [module].
SyncModuleDescriptor syncModuleDescriptor(SyncModuleType module) {
  return syncModuleDescriptors[module]!;
}

/// All registered sync module descriptors.
const Map<SyncModuleType, SyncModuleDescriptor> syncModuleDescriptors =
    <SyncModuleType, SyncModuleDescriptor>{
  SyncModuleType.personManagement: SyncModuleDescriptor(
    module: SyncModuleType.personManagement,
    hiveBoxName: HiveBoxNames.personManagement,
    firestoreCollection: FirestoreCollections.personManagement,
  ),
  SyncModuleType.laborManagement: SyncModuleDescriptor(
    module: SyncModuleType.laborManagement,
    hiveBoxName: HiveBoxNames.laborManagement,
    firestoreCollection: FirestoreCollections.laborManagement,
  ),
  SyncModuleType.materialPurchases: SyncModuleDescriptor(
    module: SyncModuleType.materialPurchases,
    hiveBoxName: HiveBoxNames.materialPurchases,
    firestoreCollection: FirestoreCollections.materialPurchases,
  ),
  SyncModuleType.truckExpenses: SyncModuleDescriptor(
    module: SyncModuleType.truckExpenses,
    hiveBoxName: HiveBoxNames.truckExpenses,
    firestoreCollection: FirestoreCollections.truckExpenses,
  ),
  SyncModuleType.maintenanceExpenses: SyncModuleDescriptor(
    module: SyncModuleType.maintenanceExpenses,
    hiveBoxName: HiveBoxNames.maintenanceExpenses,
    firestoreCollection: FirestoreCollections.maintenanceExpenses,
  ),
  SyncModuleType.electricityExpenses: SyncModuleDescriptor(
    module: SyncModuleType.electricityExpenses,
    hiveBoxName: HiveBoxNames.electricityExpenses,
    firestoreCollection: FirestoreCollections.electricityExpenses,
  ),
  SyncModuleType.miscellaneousExpenses: SyncModuleDescriptor(
    module: SyncModuleType.miscellaneousExpenses,
    hiveBoxName: HiveBoxNames.miscellaneousExpenses,
    firestoreCollection: FirestoreCollections.miscellaneousExpenses,
  ),
  SyncModuleType.recurringExpenses: SyncModuleDescriptor(
    module: SyncModuleType.recurringExpenses,
    hiveBoxName: HiveBoxNames.recurringExpenses,
    firestoreCollection: FirestoreCollections.recurringExpenses,
  ),
  SyncModuleType.factoryStatus: SyncModuleDescriptor(
    module: SyncModuleType.factoryStatus,
    hiveBoxName: HiveBoxNames.factoryStatus,
    firestoreCollection: FirestoreCollections.factoryStatus,
  ),
};
