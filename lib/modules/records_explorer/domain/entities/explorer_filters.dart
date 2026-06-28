import 'package:equatable/equatable.dart';

import '../../../../core/enums/sync_status.dart';
import '../enums/enums.dart';
import '../../../calendar_management/ui/widget/calendar_event_type.dart';

/// Advanced filter criteria for Records Explorer.
class ExplorerFilters extends Equatable {
  /// Creates [ExplorerFilters].
  const ExplorerFilters({
    this.searchQuery = '',
    this.datePreset = ExplorerDatePreset.none,
    this.customStartDate,
    this.customEndDate,
    this.includePersons = true,
    this.includeLabor = true,
    this.includeMaterialPurchase = true,
    this.includeTruckExpense = true,
    this.includeMaintenanceExpense = true,
    this.includeElectricityExpense = true,
    this.includeMiscellaneousExpense = true,
    this.includeRecurringExpense = true,
    this.includeFactoryStatus = true,
    this.includeCalendarEvents = true,
    this.calendarEventTypes = const <CalendarEventType>[
      CalendarEventType.recurringExpense,
      CalendarEventType.factoryEvent,
      CalendarEventType.maintenanceReminder,
      CalendarEventType.holiday,
    ],
    this.minAmount,
    this.maxAmount,
    this.syncStatuses = const <SyncStatus>[
      SyncStatus.pending,
      SyncStatus.synced,
      SyncStatus.failed,
    ],
    this.sortOption = ExplorerSortOption.dateDescending,
  });

  /// Global text search query.
  final String searchQuery;

  /// Selected date preset.
  final ExplorerDatePreset datePreset;

  /// Custom range start when [datePreset] is [ExplorerDatePreset.custom].
  final DateTime? customStartDate;

  /// Custom range end when [datePreset] is [ExplorerDatePreset.custom].
  final DateTime? customEndDate;

  /// Include person records.
  final bool includePersons;

  /// Include labor records.
  final bool includeLabor;

  /// Include material purchase expenses.
  final bool includeMaterialPurchase;

  /// Include truck expenses.
  final bool includeTruckExpense;

  /// Include maintenance expenses.
  final bool includeMaintenanceExpense;

  /// Include electricity expenses.
  final bool includeElectricityExpense;

  /// Include miscellaneous expenses.
  final bool includeMiscellaneousExpense;

  /// Include recurring expenses.
  final bool includeRecurringExpense;

  /// Include factory status history.
  final bool includeFactoryStatus;

  /// Include calendar events.
  final bool includeCalendarEvents;

  /// Calendar event types to include.
  final List<CalendarEventType> calendarEventTypes;

  /// Minimum amount filter.
  final double? minAmount;

  /// Maximum amount filter.
  final double? maxAmount;

  /// Sync statuses to include.
  final List<SyncStatus> syncStatuses;

  /// Result sort order.
  final ExplorerSortOption sortOption;

  /// Whether any non-default filter is active.
  bool get hasActiveFilters {
    return searchQuery.trim().isNotEmpty ||
        datePreset != ExplorerDatePreset.none ||
        !includePersons ||
        !includeLabor ||
        !includeMaterialPurchase ||
        !includeTruckExpense ||
        !includeMaintenanceExpense ||
        !includeElectricityExpense ||
        !includeMiscellaneousExpense ||
        !includeRecurringExpense ||
        !includeFactoryStatus ||
        !includeCalendarEvents ||
        calendarEventTypes.length != CalendarEventType.values.length ||
        minAmount != null ||
        maxAmount != null ||
        syncStatuses.length != SyncStatus.values.length ||
        sortOption != ExplorerSortOption.dateDescending;
  }

  /// Returns a copy with selective overrides.
  ExplorerFilters copyWith({
    String? searchQuery,
    ExplorerDatePreset? datePreset,
    DateTime? customStartDate,
    DateTime? customEndDate,
    bool? includePersons,
    bool? includeLabor,
    bool? includeMaterialPurchase,
    bool? includeTruckExpense,
    bool? includeMaintenanceExpense,
    bool? includeElectricityExpense,
    bool? includeMiscellaneousExpense,
    bool? includeRecurringExpense,
    bool? includeFactoryStatus,
    bool? includeCalendarEvents,
    List<CalendarEventType>? calendarEventTypes,
    double? minAmount,
    double? maxAmount,
    bool clearMinAmount = false,
    bool clearMaxAmount = false,
    List<SyncStatus>? syncStatuses,
    ExplorerSortOption? sortOption,
    bool clearCustomDates = false,
  }) {
    return ExplorerFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      datePreset: datePreset ?? this.datePreset,
      customStartDate:
          clearCustomDates ? null : customStartDate ?? this.customStartDate,
      customEndDate:
          clearCustomDates ? null : customEndDate ?? this.customEndDate,
      includePersons: includePersons ?? this.includePersons,
      includeLabor: includeLabor ?? this.includeLabor,
      includeMaterialPurchase:
          includeMaterialPurchase ?? this.includeMaterialPurchase,
      includeTruckExpense: includeTruckExpense ?? this.includeTruckExpense,
      includeMaintenanceExpense:
          includeMaintenanceExpense ?? this.includeMaintenanceExpense,
      includeElectricityExpense:
          includeElectricityExpense ?? this.includeElectricityExpense,
      includeMiscellaneousExpense:
          includeMiscellaneousExpense ?? this.includeMiscellaneousExpense,
      includeRecurringExpense:
          includeRecurringExpense ?? this.includeRecurringExpense,
      includeFactoryStatus: includeFactoryStatus ?? this.includeFactoryStatus,
      includeCalendarEvents:
          includeCalendarEvents ?? this.includeCalendarEvents,
      calendarEventTypes: calendarEventTypes ?? this.calendarEventTypes,
      minAmount: clearMinAmount ? null : minAmount ?? this.minAmount,
      maxAmount: clearMaxAmount ? null : maxAmount ?? this.maxAmount,
      syncStatuses: syncStatuses ?? this.syncStatuses,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  /// Resets filters to defaults.
  ExplorerFilters cleared() => const ExplorerFilters();

  @override
  List<Object?> get props => <Object?>[
        searchQuery,
        datePreset,
        customStartDate,
        customEndDate,
        includePersons,
        includeLabor,
        includeMaterialPurchase,
        includeTruckExpense,
        includeMaintenanceExpense,
        includeElectricityExpense,
        includeMiscellaneousExpense,
        includeRecurringExpense,
        includeFactoryStatus,
        includeCalendarEvents,
        calendarEventTypes,
        minAmount,
        maxAmount,
        syncStatuses,
        sortOption,
      ];
}
