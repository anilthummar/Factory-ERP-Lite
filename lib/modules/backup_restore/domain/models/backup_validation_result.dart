/// Restore validation outcome before importing a backup file.
class BackupValidationResult {
  /// Creates [BackupValidationResult].
  const BackupValidationResult({
    required this.isValid,
    required this.errors,
    required this.recordCountsByModule,
    required this.totalRecords,
    this.formatVersion,
    this.exportedAt,
  });

  /// Whether the backup file can be safely restored.
  final bool isValid;

  /// Validation error messages when [isValid] is false.
  final List<String> errors;

  /// Parsed record counts per module key.
  final Map<String, int> recordCountsByModule;

  /// Sum of all module record counts.
  final int totalRecords;

  /// Backup format version from the file header.
  final int? formatVersion;

  /// ISO timestamp from the backup file header.
  final String? exportedAt;
}
