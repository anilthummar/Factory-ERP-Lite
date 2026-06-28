import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/entities/factory_status_entity.dart';
import '../../../core/domain/entities/labor_entity.dart';
import '../../../core/domain/entities/person_entity.dart';
import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../core/domain/enums/expense_category.dart';
import '../../../core/enums/sync_status.dart';
import '../../calendar_management/ui/widget/calendar_event_type.dart';
import '../domain/entities/explorer_record_item.dart';
import '../domain/enums/explorer_module_type.dart';

/// Maps domain entities to unified [ExplorerRecordItem] rows.
abstract final class ExplorerRecordMapper {
  static ExplorerRecordItem fromPerson(PersonEntity person) {
    final String search = <String?>[
      person.name,
      person.mobile,
      person.address,
      person.notes,
    ].whereType<String>().join(' ').toLowerCase();

    return ExplorerRecordItem(
      id: 'person_${person.id}',
      sourceId: person.id,
      moduleType: ExplorerModuleType.person,
      name: person.name,
      category: 'person',
      recordDate: person.updatedAt,
      syncStatus: person.syncStatus,
      notes: person.notes ?? person.address,
      searchText: search,
    );
  }

  static ExplorerRecordItem fromLabor(LaborEntity labor) {
    final String search = <String?>[
      labor.name,
      labor.mobile,
      labor.skill,
      labor.notes,
    ].whereType<String>().join(' ').toLowerCase();

    return ExplorerRecordItem(
      id: 'labor_${labor.id}',
      sourceId: labor.id,
      moduleType: ExplorerModuleType.labor,
      name: labor.name,
      category: labor.skill,
      recordDate: labor.updatedAt,
      syncStatus: labor.syncStatus,
      amount: labor.dailyWage,
      notes: labor.notes,
      searchText: search,
    );
  }

  static ExplorerRecordItem fromExpense(ExpenseEntity expense) {
    final ExplorerModuleType moduleType = _moduleForCategory(expense.category);
    final String search = <String?>[
      expense.title,
      expense.notes,
      expense.category.name,
    ].whereType<String>().join(' ').toLowerCase();

    return ExplorerRecordItem(
      id: '${expense.category.name}_${expense.id}',
      sourceId: expense.id,
      moduleType: moduleType,
      name: expense.title,
      category: expense.category.name,
      recordDate: expense.date,
      syncStatus: expense.syncStatus,
      amount: expense.amount,
      notes: expense.notes,
      searchText: search,
    );
  }

  static ExplorerRecordItem fromRecurring(RecurringExpenseEntity expense) {
    final String search = <String?>[
      expense.title,
      expense.notes,
      expense.frequency.name,
    ].whereType<String>().join(' ').toLowerCase();

    return ExplorerRecordItem(
      id: 'recurring_${expense.id}',
      sourceId: expense.id,
      moduleType: ExplorerModuleType.recurringExpense,
      name: expense.title,
      category: expense.frequency.name,
      recordDate: expense.startDate,
      syncStatus: expense.syncStatus,
      amount: expense.amount,
      notes: expense.notes,
      searchText: search,
    );
  }

  static ExplorerRecordItem fromFactoryStatus(FactoryStatusEntity status) {
    final String search = <String?>[
      status.status.name,
      status.notes,
    ].whereType<String>().join(' ').toLowerCase();

    return ExplorerRecordItem(
      id: 'factory_${status.id}',
      sourceId: status.id,
      moduleType: ExplorerModuleType.factoryStatus,
      name: status.status.name,
      category: status.status.name,
      recordDate: status.updatedAt,
      syncStatus: status.syncStatus,
      notes: status.notes,
      searchText: search,
    );
  }

  static ExplorerRecordItem fromCalendarEvent(CalendarEventData event) {
    return ExplorerRecordItem(
      id: 'calendar_${event.id}',
      sourceId: event.id,
      moduleType: ExplorerModuleType.calendarEvent,
      name: event.title,
      category: event.type.name,
      recordDate: event.date,
      syncStatus: SyncStatus.synced,
      searchText: '${event.title} ${event.type.name}'.toLowerCase(),
    );
  }

  static ExplorerModuleType _moduleForCategory(ExpenseCategory category) {
    return switch (category) {
      ExpenseCategory.materialPurchase =>
        ExplorerModuleType.materialPurchase,
      ExpenseCategory.truck => ExplorerModuleType.truckExpense,
      ExpenseCategory.maintenance => ExplorerModuleType.maintenanceExpense,
      ExpenseCategory.electricity => ExplorerModuleType.electricityExpense,
      ExpenseCategory.miscellaneous =>
        ExplorerModuleType.miscellaneousExpense,
    };
  }
}
