/// Result of exporting factory data to Google Sheets.
class GoogleSheetsBackupResult {
  /// Creates [GoogleSheetsBackupResult].
  const GoogleSheetsBackupResult({
    required this.spreadsheetId,
    required this.spreadsheetUrl,
    required this.recordCount,
  });

  /// Google Sheets spreadsheet identifier.
  final String spreadsheetId;

  /// Browser URL for the created spreadsheet.
  final String spreadsheetUrl;

  /// Total records exported to the spreadsheet.
  final int recordCount;
}
