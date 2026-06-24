/// JSON backup format metadata.
abstract final class BackupManifest {
  /// Current backup file format version.
  static const int currentVersion = 1;

  /// Application identifier stored in backup files.
  static const String appId = 'factory_erp_lite';

  /// File extension for JSON backups.
  static const String fileExtension = 'json';
}
