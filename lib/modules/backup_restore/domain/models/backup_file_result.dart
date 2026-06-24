/// Result of saving a JSON backup file locally.
class BackupFileResult {
  /// Creates [BackupFileResult].
  const BackupFileResult({
    required this.fileName,
    required this.filePath,
    required this.jsonContent,
    required this.recordCount,
  });

  /// Saved backup file name.
  final String fileName;

  /// Absolute path to the saved backup file.
  final String filePath;

  /// Raw JSON backup content.
  final String jsonContent;

  /// Total records included in the backup.
  final int recordCount;
}
