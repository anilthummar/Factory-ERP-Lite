/// Field keys for items stored in the Hive sync queue box.
abstract final class SyncQueueKeys {
  static const String queueId = 'queueId';
  static const String module = 'module';
  static const String recordId = 'recordId';
  static const String operation = 'operation';
  static const String status = 'status';
  static const String attemptCount = 'attemptCount';
  static const String createdAtMs = 'createdAtMs';
  static const String updatedAtMs = 'updatedAtMs';
  static const String lastError = 'lastError';
  static const String factoryId = 'factoryId';
}
