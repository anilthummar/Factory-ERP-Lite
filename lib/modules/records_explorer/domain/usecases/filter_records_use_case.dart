import '../../../../core/enums/sync_status.dart';
import '../../../calendar_management/ui/widget/calendar_event_type.dart';
import '../entities/entities.dart';
import '../enums/enums.dart';

/// Applies advanced filters, sorting, and summary stats to explorer records.
class FilterRecordsUseCase {
  /// Creates [FilterRecordsUseCase].
  const FilterRecordsUseCase();

  /// Filters and sorts [records] using [filters].
  List<ExplorerRecordItem> call({
    required List<ExplorerRecordItem> records,
    required ExplorerFilters filters,
  }) {
    final (DateTime?, DateTime?) range = _resolveDateRange(filters);
    final DateTime? rangeStart = range.$1;
    final DateTime? rangeEnd = range.$2;

    final List<ExplorerRecordItem> filtered = records.where((ExplorerRecordItem record) {
      if (!_matchesModule(record, filters)) {
        return false;
      }
      if (!filters.syncStatuses.contains(record.syncStatus)) {
        return false;
      }
      if (rangeStart != null && rangeEnd != null) {
        final DateTime date = DateTime(
          record.recordDate.year,
          record.recordDate.month,
          record.recordDate.day,
        );
        if (date.isBefore(rangeStart) || date.isAfter(rangeEnd)) {
          return false;
        }
      }
      if (record.amount != null) {
        if (filters.minAmount != null && record.amount! < filters.minAmount!) {
          return false;
        }
        if (filters.maxAmount != null && record.amount! > filters.maxAmount!) {
          return false;
        }
      } else if (filters.minAmount != null || filters.maxAmount != null) {
        return false;
      }
      return true;
    }).toList(growable: false);

    filtered.sort((ExplorerRecordItem a, ExplorerRecordItem b) {
      return switch (filters.sortOption) {
        ExplorerSortOption.dateDescending =>
          b.recordDate.compareTo(a.recordDate),
        ExplorerSortOption.dateAscending =>
          a.recordDate.compareTo(b.recordDate),
        ExplorerSortOption.amountDescending => _compareAmount(b, a),
        ExplorerSortOption.amountAscending => _compareAmount(a, b),
        ExplorerSortOption.nameAscending =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      };
    });

    return filtered;
  }

  /// Builds summary metrics for [records].
  ExplorerSummaryStats summarize(List<ExplorerRecordItem> records) {
    final List<double> amounts = records
        .map((ExplorerRecordItem record) => record.amount)
        .whereType<double>()
        .toList(growable: false);

    final double totalAmount =
        amounts.fold<double>(0, (double sum, double value) => sum + value);

    int persons = 0;
    int labor = 0;
    int expenses = 0;
    int pending = 0;

    for (final ExplorerRecordItem record in records) {
      if (record.syncStatus == SyncStatus.pending) {
        pending++;
      }
      switch (record.moduleType) {
        case ExplorerModuleType.person:
          persons++;
        case ExplorerModuleType.labor:
          labor++;
        case ExplorerModuleType.materialPurchase:
        case ExplorerModuleType.truckExpense:
        case ExplorerModuleType.maintenanceExpense:
        case ExplorerModuleType.electricityExpense:
        case ExplorerModuleType.miscellaneousExpense:
        case ExplorerModuleType.recurringExpense:
          expenses++;
        case ExplorerModuleType.factoryStatus:
        case ExplorerModuleType.calendarEvent:
          break;
      }
    }

    double average = 0;
    double highest = 0;
    double lowest = 0;
    if (amounts.isNotEmpty) {
      average = totalAmount / amounts.length;
      highest = amounts.reduce((double a, double b) => a > b ? a : b);
      lowest = amounts.reduce((double a, double b) => a < b ? a : b);
    }

    return ExplorerSummaryStats(
      totalRecords: records.length,
      totalAmount: totalAmount,
      totalPersons: persons,
      totalLabor: labor,
      totalExpenses: expenses,
      pendingSyncCount: pending,
      averageAmount: average,
      highestAmount: highest,
      lowestAmount: lowest,
    );
  }

  bool _matchesModule(ExplorerRecordItem record, ExplorerFilters filters) {
    return switch (record.moduleType) {
      ExplorerModuleType.person => filters.includePersons,
      ExplorerModuleType.labor => filters.includeLabor,
      ExplorerModuleType.materialPurchase => filters.includeMaterialPurchase,
      ExplorerModuleType.truckExpense => filters.includeTruckExpense,
      ExplorerModuleType.maintenanceExpense =>
        filters.includeMaintenanceExpense,
      ExplorerModuleType.electricityExpense =>
        filters.includeElectricityExpense,
      ExplorerModuleType.miscellaneousExpense =>
        filters.includeMiscellaneousExpense,
      ExplorerModuleType.recurringExpense => filters.includeRecurringExpense,
      ExplorerModuleType.factoryStatus => filters.includeFactoryStatus,
      ExplorerModuleType.calendarEvent => filters.includeCalendarEvents &&
          _matchesCalendarType(record.category, filters.calendarEventTypes),
    };
  }

  bool _matchesCalendarType(
    String category,
    List<CalendarEventType> types,
  ) {
    try {
      return types.contains(CalendarEventType.values.byName(category));
    } on Object {
      return false;
    }
  }

  (DateTime?, DateTime?) _resolveDateRange(ExplorerFilters filters) {
    if (filters.datePreset == ExplorerDatePreset.none) {
      return (null, null);
    }

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    switch (filters.datePreset) {
      case ExplorerDatePreset.today:
        return (today, today);
      case ExplorerDatePreset.yesterday:
        final DateTime yesterday = today.subtract(const Duration(days: 1));
        return (yesterday, yesterday);
      case ExplorerDatePreset.thisWeek:
        final int weekday = today.weekday;
        final DateTime start = today.subtract(Duration(days: weekday - 1));
        final DateTime end = start.add(const Duration(days: 6));
        return (start, end);
      case ExplorerDatePreset.thisMonth:
        return (
          DateTime(today.year, today.month),
          DateTime(today.year, today.month + 1, 0),
        );
      case ExplorerDatePreset.lastMonth:
        final DateTime start = DateTime(today.year, today.month - 1);
        return (start, DateTime(today.year, today.month, 0));
      case ExplorerDatePreset.custom:
        if (filters.customStartDate == null || filters.customEndDate == null) {
          return (null, null);
        }
        final DateTime start = DateTime(
          filters.customStartDate!.year,
          filters.customStartDate!.month,
          filters.customStartDate!.day,
        );
        final DateTime end = DateTime(
          filters.customEndDate!.year,
          filters.customEndDate!.month,
          filters.customEndDate!.day,
        );
        return (start, end);
      case ExplorerDatePreset.none:
        return (null, null);
    }
  }

  int _compareAmount(ExplorerRecordItem a, ExplorerRecordItem b) {
    final double amountA = a.amount ?? -1;
    final double amountB = b.amount ?? -1;
    return amountA.compareTo(amountB);
  }
}
