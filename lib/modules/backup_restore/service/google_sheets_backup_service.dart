import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:intl/intl.dart';

import '../../../base/base_config.dart';
import '../datasource/backup_local_data_source.dart';
import '../domain/models/google_sheets_backup_result.dart';

/// Exports factory data to a new Google Spreadsheet.
class GoogleSheetsBackupService {
  /// Creates [GoogleSheetsBackupService].
  GoogleSheetsBackupService({
    required BackupLocalDataSource localDataSource,
    GoogleSignIn? googleSignIn,
  })  : _localDataSource = localDataSource,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: <String>[
                SheetsApi.spreadsheetsScope,
                'email',
              ],
              serverClientId: configGoogleWebClientId,
            );

  final BackupLocalDataSource _localDataSource;
  final GoogleSignIn _googleSignIn;

  /// Creates a spreadsheet and writes module tabs from local Hive data.
  Future<GoogleSheetsBackupResult> exportToNewSpreadsheet() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) {
      throw StateError('Google sign-in was cancelled.');
    }

    final auth.AuthClient? authClient =
        await _googleSignIn.authenticatedClient();
    if (authClient == null) {
      throw StateError('Failed to obtain Google API credentials.');
    }

    final SheetsApi sheetsApi = SheetsApi(authClient);
    final DateTime exportedAt = DateTime.now();
    final String title =
        'Factory ERP Lite Backup ${DateFormat('yyyy-MM-dd HH:mm').format(exportedAt)}';

    final Spreadsheet created = await sheetsApi.spreadsheets.create(
      Spreadsheet(
        properties: SpreadsheetProperties(title: title),
      ),
    );

    final String spreadsheetId = created.spreadsheetId!;
    final int defaultSheetId = created.sheets!.first.properties!.sheetId!;
    final Map<String, dynamic> modules =
        await _localDataSource.exportAllModules();
    int recordCount = 0;

    await sheetsApi.spreadsheets.batchUpdate(
      BatchUpdateSpreadsheetRequest(
        requests: <Request>[
          Request(
            updateSheetProperties: UpdateSheetPropertiesRequest(
              properties: SheetProperties(
                sheetId: defaultSheetId,
                title: 'Summary',
              ),
              fields: 'title',
            ),
          ),
        ],
      ),
      spreadsheetId,
    );

    final Map<String, int> counts = await _localDataSource.recordCounts();
    await sheetsApi.spreadsheets.values.update(
      ValueRange(
        values: <List<Object?>>[
          <Object?>['Factory ERP Lite Backup'],
          <Object?>['Exported At', exportedAt.toUtc().toIso8601String()],
          <Object?>[],
          <Object?>['Module', 'Records'],
          ...counts.entries.map(
            (MapEntry<String, int> entry) =>
                <Object?>[entry.key, entry.value],
          ),
        ],
      ),
      spreadsheetId,
      'Summary!A1',
      valueInputOption: 'USER_ENTERED',
    );

    recordCount += await _addDataSheet(
      sheetsApi: sheetsApi,
      spreadsheetId: spreadsheetId,
      sheetTitle: 'Persons',
      headers: <String>['Name', 'Mobile', 'Address', 'Notes', 'Sync Status'],
      rows: _mapRows(
        modules['person_management'],
        (Map<String, dynamic> map) => <String>[
          map['name'] as String? ?? '',
          map['mobile'] as String? ?? '',
          map['address'] as String? ?? '',
          map['notes'] as String? ?? '',
          map['syncStatusValue'] as String? ?? '',
        ],
      ),
    );

    recordCount += await _addDataSheet(
      sheetsApi: sheetsApi,
      spreadsheetId: spreadsheetId,
      sheetTitle: 'Labor',
      headers: <String>[
        'Name',
        'Skill',
        'Mobile',
        'Daily Wage',
        'Notes',
        'Sync Status',
      ],
      rows: _mapRows(
        modules['labor_management'],
        (Map<String, dynamic> map) => <String>[
          map['name'] as String? ?? '',
          map['skill'] as String? ?? '',
          map['mobile'] as String? ?? '',
          '${map['dailyWage'] ?? ''}',
          map['notes'] as String? ?? '',
          map['syncStatusValue'] as String? ?? '',
        ],
      ),
    );

    final List<List<String>> expenseRows = <List<String>>[];
    const List<String> expenseBoxes = <String>[
      'material_purchases',
      'truck_expenses',
      'maintenance_expenses',
      'electricity_expenses',
      'miscellaneous_expenses',
    ];
    for (final String boxName in expenseBoxes) {
      final List<dynamic> entries =
          modules[boxName] as List<dynamic>? ?? <dynamic>[];
      recordCount += entries.length;
      for (final dynamic row in entries) {
        final Map<String, dynamic> map =
            Map<String, dynamic>.from(row as Map<dynamic, dynamic>);
        expenseRows.add(<String>[
          boxName,
          map['title'] as String? ?? '',
          '${map['amount'] ?? ''}',
          DateFormat('yyyy-MM-dd').format(
            DateTime.fromMillisecondsSinceEpoch(map['dateMs'] as int? ?? 0),
          ),
          map['categoryValue'] as String? ?? '',
          map['notes'] as String? ?? '',
          map['syncStatusValue'] as String? ?? '',
        ]);
      }
    }

    await _addDataSheet(
      sheetsApi: sheetsApi,
      spreadsheetId: spreadsheetId,
      sheetTitle: 'Expenses',
      headers: <String>[
        'Module',
        'Title',
        'Amount',
        'Date',
        'Category',
        'Notes',
        'Sync Status',
      ],
      rows: expenseRows,
    );

    recordCount += await _addDataSheet(
      sheetsApi: sheetsApi,
      spreadsheetId: spreadsheetId,
      sheetTitle: 'Recurring',
      headers: <String>[
        'Title',
        'Amount',
        'Frequency',
        'Start Date',
        'End Date',
        'Notes',
      ],
      rows: _mapRows(
        modules['recurring_expenses'],
        (Map<String, dynamic> map) => <String>[
          map['title'] as String? ?? '',
          '${map['amount'] ?? ''}',
          map['frequencyValue'] as String? ?? '',
          DateFormat('yyyy-MM-dd').format(
            DateTime.fromMillisecondsSinceEpoch(
              map['startDateMs'] as int? ?? 0,
            ),
          ),
          map['endDateMs'] == null
              ? ''
              : DateFormat('yyyy-MM-dd').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    map['endDateMs'] as int,
                  ),
                ),
          map['notes'] as String? ?? '',
        ],
      ),
    );

    return GoogleSheetsBackupResult(
      spreadsheetId: spreadsheetId,
      spreadsheetUrl: 'https://docs.google.com/spreadsheets/d/$spreadsheetId',
      recordCount: recordCount,
    );
  }

  List<List<String>> _mapRows(
    dynamic raw,
    List<String> Function(Map<String, dynamic> map) mapper,
  ) {
    final List<dynamic> entries = raw as List<dynamic>? ?? <dynamic>[];
    return entries
        .map((dynamic row) => mapper(
              Map<String, dynamic>.from(row as Map<dynamic, dynamic>),
            ))
        .toList(growable: false);
  }

  Future<int> _addDataSheet({
    required SheetsApi sheetsApi,
    required String spreadsheetId,
    required String sheetTitle,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    await sheetsApi.spreadsheets.batchUpdate(
      BatchUpdateSpreadsheetRequest(
        requests: <Request>[
          Request(
            addSheet: AddSheetRequest(
              properties: SheetProperties(title: sheetTitle),
            ),
          ),
        ],
      ),
      spreadsheetId,
    );

    await sheetsApi.spreadsheets.values.update(
      ValueRange(
        values: <List<Object?>>[
          headers,
          ...rows,
        ],
      ),
      spreadsheetId,
      '$sheetTitle!A1',
      valueInputOption: 'USER_ENTERED',
    );

    return rows.length;
  }
}
