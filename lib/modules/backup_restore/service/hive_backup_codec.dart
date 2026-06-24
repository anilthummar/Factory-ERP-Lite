import '../../attachments/model/local/attachment_hive_model.dart';
import '../../expense/model/local/expense_hive_model.dart';
import '../../factory_status/model/local/factory_status_hive_model.dart';
import '../../labor_management/model/local/labor_hive_model.dart';
import '../../person_management/model/local/person_hive_model.dart';
import '../../recurring_expenses/model/local/recurring_expense_hive_model.dart';

/// Serializes Hive models to JSON-safe maps for backup/restore.
abstract final class HiveBackupCodec {
  static Map<String, dynamic> personToMap(PersonHiveModel model) {
    return <String, dynamic>{
      'id': model.id,
      'createdAtMs': model.createdAtMs,
      'updatedAtMs': model.updatedAtMs,
      'syncStatusValue': model.syncStatusValue,
      'name': model.name,
      'mobile': model.mobile,
      'address': model.address,
      'notes': model.notes,
    };
  }

  static PersonHiveModel personFromMap(Map<String, dynamic> map) {
    return PersonHiveModel(
      id: map['id'] as String,
      createdAtMs: map['createdAtMs'] as int,
      updatedAtMs: map['updatedAtMs'] as int,
      syncStatusValue: map['syncStatusValue'] as String,
      name: map['name'] as String,
      mobile: map['mobile'] as String,
      address: map['address'] as String?,
      notes: map['notes'] as String?,
    );
  }

  static Map<String, dynamic> laborToMap(LaborHiveModel model) {
    return <String, dynamic>{
      'id': model.id,
      'createdAtMs': model.createdAtMs,
      'updatedAtMs': model.updatedAtMs,
      'syncStatusValue': model.syncStatusValue,
      'name': model.name,
      'mobile': model.mobile,
      'skill': model.skill,
      'dailyWage': model.dailyWage,
      'notes': model.notes,
    };
  }

  static LaborHiveModel laborFromMap(Map<String, dynamic> map) {
    return LaborHiveModel(
      id: map['id'] as String,
      createdAtMs: map['createdAtMs'] as int,
      updatedAtMs: map['updatedAtMs'] as int,
      syncStatusValue: map['syncStatusValue'] as String,
      name: map['name'] as String,
      mobile: map['mobile'] as String,
      skill: map['skill'] as String,
      dailyWage: (map['dailyWage'] as num).toDouble(),
      notes: map['notes'] as String?,
    );
  }

  static Map<String, dynamic> expenseToMap(ExpenseHiveModel model) {
    return <String, dynamic>{
      'id': model.id,
      'createdAtMs': model.createdAtMs,
      'updatedAtMs': model.updatedAtMs,
      'syncStatusValue': model.syncStatusValue,
      'title': model.title,
      'amount': model.amount,
      'dateMs': model.dateMs,
      'categoryValue': model.categoryValue,
      'notes': model.notes,
      'attachmentPath': model.attachmentPath,
    };
  }

  static ExpenseHiveModel expenseFromMap(Map<String, dynamic> map) {
    return ExpenseHiveModel(
      id: map['id'] as String,
      createdAtMs: map['createdAtMs'] as int,
      updatedAtMs: map['updatedAtMs'] as int,
      syncStatusValue: map['syncStatusValue'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      dateMs: map['dateMs'] as int,
      categoryValue: map['categoryValue'] as String,
      notes: map['notes'] as String?,
      attachmentPath: map['attachmentPath'] as String?,
    );
  }

  static Map<String, dynamic> recurringExpenseToMap(
    RecurringExpenseHiveModel model,
  ) {
    return <String, dynamic>{
      'id': model.id,
      'createdAtMs': model.createdAtMs,
      'updatedAtMs': model.updatedAtMs,
      'syncStatusValue': model.syncStatusValue,
      'title': model.title,
      'amount': model.amount,
      'frequencyValue': model.frequencyValue,
      'startDateMs': model.startDateMs,
      'endDateMs': model.endDateMs,
      'notes': model.notes,
    };
  }

  static RecurringExpenseHiveModel recurringExpenseFromMap(
    Map<String, dynamic> map,
  ) {
    return RecurringExpenseHiveModel(
      id: map['id'] as String,
      createdAtMs: map['createdAtMs'] as int,
      updatedAtMs: map['updatedAtMs'] as int,
      syncStatusValue: map['syncStatusValue'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      frequencyValue: map['frequencyValue'] as String,
      startDateMs: map['startDateMs'] as int,
      endDateMs: map['endDateMs'] as int?,
      notes: map['notes'] as String?,
    );
  }

  static Map<String, dynamic> factoryStatusToMap(FactoryStatusHiveModel model) {
    return <String, dynamic>{
      'id': model.id,
      'createdAtMs': model.createdAtMs,
      'updatedAtMs': model.updatedAtMs,
      'syncStatusValue': model.syncStatusValue,
      'statusValue': model.statusValue,
      'notes': model.notes,
    };
  }

  static FactoryStatusHiveModel factoryStatusFromMap(Map<String, dynamic> map) {
    return FactoryStatusHiveModel(
      id: map['id'] as String,
      createdAtMs: map['createdAtMs'] as int,
      updatedAtMs: map['updatedAtMs'] as int,
      syncStatusValue: map['syncStatusValue'] as String,
      statusValue: map['statusValue'] as String,
      notes: map['notes'] as String?,
    );
  }

  static Map<String, dynamic> attachmentToMap(AttachmentHiveModel model) {
    return <String, dynamic>{
      'id': model.id,
      'createdAtMs': model.createdAtMs,
      'updatedAtMs': model.updatedAtMs,
      'syncStatusValue': model.syncStatusValue,
      'fileName': model.fileName,
      'localPath': model.localPath,
      'mimeType': model.mimeType,
      'fileSizeBytes': model.fileSizeBytes,
      'attachmentTypeValue': model.attachmentTypeValue,
      'parentModuleValue': model.parentModuleValue,
      'parentRecordId': model.parentRecordId,
      'downloadUrl': model.downloadUrl,
      'storagePath': model.storagePath,
    };
  }

  static AttachmentHiveModel attachmentFromMap(Map<String, dynamic> map) {
    return AttachmentHiveModel(
      id: map['id'] as String,
      createdAtMs: map['createdAtMs'] as int,
      updatedAtMs: map['updatedAtMs'] as int,
      syncStatusValue: map['syncStatusValue'] as String,
      fileName: map['fileName'] as String,
      localPath: map['localPath'] as String,
      mimeType: map['mimeType'] as String,
      fileSizeBytes: map['fileSizeBytes'] as int,
      attachmentTypeValue: map['attachmentTypeValue'] as String,
      parentModuleValue: map['parentModuleValue'] as String?,
      parentRecordId: map['parentRecordId'] as String?,
      downloadUrl: map['downloadUrl'] as String?,
      storagePath: map['storagePath'] as String?,
    );
  }

  static List<Map<String, dynamic>> mapBoxToList(
    Map<dynamic, dynamic> entries,
  ) {
    return entries.entries
        .map(
          (MapEntry<dynamic, dynamic> entry) => <String, dynamic>{
            'key': entry.key.toString(),
            'value': _deepStringifyMap(entry.value),
          },
        )
        .toList(growable: false);
  }

  static Map<dynamic, dynamic> mapListToBox(List<dynamic> entries) {
    final Map<dynamic, dynamic> boxData = <dynamic, dynamic>{};
    for (final dynamic entry in entries) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(
        entry as Map<dynamic, dynamic>,
      );
      boxData[map['key']] = _deepRestoreMap(map['value']);
    }
    return boxData;
  }

  static Map<String, dynamic> _deepStringifyMap(dynamic value) {
    if (value is Map) {
      return value.map(
        (dynamic key, dynamic nested) =>
            MapEntry<String, dynamic>(key.toString(), _deepStringify(nested)),
      );
    }
    return <String, dynamic>{'value': _deepStringify(value)};
  }

  static dynamic _deepStringify(dynamic value) {
    if (value is Map) {
      return value.map(
        (dynamic key, dynamic nested) =>
            MapEntry<String, dynamic>(key.toString(), _deepStringify(nested)),
      );
    }
    if (value is List) {
      return value.map(_deepStringify).toList();
    }
    return value;
  }

  static dynamic _deepRestoreMap(dynamic value) {
    if (value is Map) {
      if (value.length == 1 && value.containsKey('value')) {
        return value['value'];
      }
      return value.map(
        (dynamic key, dynamic nested) =>
            MapEntry<dynamic, dynamic>(key, _deepRestoreMap(nested)),
      );
    }
    if (value is List) {
      return value.map(_deepRestoreMap).toList();
    }
    return value;
  }
}
