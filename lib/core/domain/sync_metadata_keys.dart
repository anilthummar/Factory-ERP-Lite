/// Shared field keys for syncable Hive maps and Firestore documents.
abstract final class SyncMetadataKeys {
  static const String id = 'id';
  static const String syncStatus = 'syncStatus';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String factoryId = 'factoryId';
  static const String isDeleted = 'isDeleted';
}
