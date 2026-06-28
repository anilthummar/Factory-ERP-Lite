import '../../../../core/enums/sync_status.dart';
import '../../../../utils/exports.dart';
import '../../../calendar_management/ui/widget/calendar_event_type.dart';
import '../../domain/entities/explorer_filters.dart';
import '../../domain/enums/enums.dart';

/// Advanced filter bottom sheet for Records Explorer.
class ExplorerFilterSheet extends StatefulWidget {
  /// Creates [ExplorerFilterSheet].
  const ExplorerFilterSheet({
    required this.initialFilters,
    required this.onApply,
    super.key,
  });

  /// Starting filter values.
  final ExplorerFilters initialFilters;

  /// Called when the user applies filters.
  final ValueChanged<ExplorerFilters> onApply;

  /// Opens the filter sheet.
  static Future<void> show(
    BuildContext context, {
    required ExplorerFilters initialFilters,
    required ValueChanged<ExplorerFilters> onApply,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: ExplorerFilterSheet(
            initialFilters: initialFilters,
            onApply: onApply,
          ),
        );
      },
    );
  }

  @override
  State<ExplorerFilterSheet> createState() => _ExplorerFilterSheetState();
}

class _ExplorerFilterSheetState extends State<ExplorerFilterSheet> {
  late ExplorerFilters _filters;
  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _minAmountController.text =
        _filters.minAmount?.toStringAsFixed(0) ?? '';
    _maxAmountController.text =
        _filters.maxAmount?.toStringAsFixed(0) ?? '';
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  void _apply() {
    final double? minAmount = double.tryParse(_minAmountController.text.trim());
    final double? maxAmount = double.tryParse(_maxAmountController.text.trim());
    widget.onApply(
      _filters.copyWith(
        minAmount: minAmount,
        maxAmount: maxAmount,
        clearMinAmount: _minAmountController.text.trim().isEmpty,
        clearMaxAmount: _maxAmountController.text.trim().isEmpty,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              strings.recordsExplorerFiltersKey,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Dimens.space16),
            Text(strings.recordsExplorerDateFilterKey),
            const SizedBox(height: Dimens.space8),
            Wrap(
              spacing: 8,
              children: ExplorerDatePreset.values.map((ExplorerDatePreset preset) {
                return FilterChip(
                  label: Text(_datePresetLabel(strings, preset)),
                  selected: _filters.datePreset == preset,
                  onSelected: (bool selected) {
                    setState(() {
                      _filters = _filters.copyWith(
                        datePreset: selected ? preset : ExplorerDatePreset.none,
                      );
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: Dimens.space16),
            Text(strings.recordsExplorerSortKey),
            const SizedBox(height: Dimens.space8),
            DropdownButtonFormField<ExplorerSortOption>(
              value: _filters.sortOption,
              items: ExplorerSortOption.values
                  .map(
                    (ExplorerSortOption option) => DropdownMenuItem<ExplorerSortOption>(
                      value: option,
                      child: Text(_sortLabel(strings, option)),
                    ),
                  )
                  .toList(),
              onChanged: (ExplorerSortOption? value) {
                if (value != null) {
                  setState(() => _filters = _filters.copyWith(sortOption: value));
                }
              },
            ),
            const SizedBox(height: Dimens.space16),
            Text(strings.recordsExplorerAmountFilterKey),
            const SizedBox(height: Dimens.space8),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _minAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: strings.recordsExplorerMinAmountKey,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: strings.recordsExplorerMaxAmountKey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.space16),
            _Toggle(
              label: strings.totalPersonsKey,
              value: _filters.includePersons,
              onChanged: (bool value) =>
                  setState(() => _filters = _filters.copyWith(includePersons: value)),
            ),
            _Toggle(
              label: strings.totalLaborKey,
              value: _filters.includeLabor,
              onChanged: (bool value) =>
                  setState(() => _filters = _filters.copyWith(includeLabor: value)),
            ),
            _Toggle(
              label: strings.materialPurchaseKey,
              value: _filters.includeMaterialPurchase,
              onChanged: (bool value) => setState(
                () => _filters = _filters.copyWith(includeMaterialPurchase: value),
              ),
            ),
            _Toggle(
              label: strings.truckExpensesKey,
              value: _filters.includeTruckExpense,
              onChanged: (bool value) =>
                  setState(() => _filters = _filters.copyWith(includeTruckExpense: value)),
            ),
            _Toggle(
              label: strings.maintenanceExpensesKey,
              value: _filters.includeMaintenanceExpense,
              onChanged: (bool value) => setState(
                () => _filters = _filters.copyWith(includeMaintenanceExpense: value),
              ),
            ),
            _Toggle(
              label: strings.electricityExpensesKey,
              value: _filters.includeElectricityExpense,
              onChanged: (bool value) => setState(
                () => _filters = _filters.copyWith(includeElectricityExpense: value),
              ),
            ),
            _Toggle(
              label: strings.miscExpensesKey,
              value: _filters.includeMiscellaneousExpense,
              onChanged: (bool value) => setState(
                () =>
                    _filters = _filters.copyWith(includeMiscellaneousExpense: value),
              ),
            ),
            _Toggle(
              label: strings.recurringExpensesKey,
              value: _filters.includeRecurringExpense,
              onChanged: (bool value) => setState(
                () => _filters = _filters.copyWith(includeRecurringExpense: value),
              ),
            ),
            _Toggle(
              label: strings.factoryStatusKey,
              value: _filters.includeFactoryStatus,
              onChanged: (bool value) => setState(
                () => _filters = _filters.copyWith(includeFactoryStatus: value),
              ),
            ),
            _Toggle(
              label: strings.navCalendarKey,
              value: _filters.includeCalendarEvents,
              onChanged: (bool value) => setState(
                () => _filters = _filters.copyWith(includeCalendarEvents: value),
              ),
            ),
            const SizedBox(height: Dimens.space16),
            Text(strings.recordsExplorerSyncFilterKey),
            const SizedBox(height: Dimens.space8),
            Wrap(
              spacing: 8,
              children: SyncStatus.values.map((SyncStatus status) {
                final bool selected = _filters.syncStatuses.contains(status);
                return FilterChip(
                  label: Text(status.name),
                  selected: selected,
                  onSelected: (bool value) {
                    setState(() {
                      final List<SyncStatus> next =
                          List<SyncStatus>.from(_filters.syncStatuses);
                      if (value) {
                        next.add(status);
                      } else {
                        next.remove(status);
                      }
                      _filters = _filters.copyWith(syncStatuses: next);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: Dimens.space24),
            FilledButton(
              onPressed: _apply,
              child: Text(strings.applyFilterKey),
            ),
          ],
        ),
      ),
    );
  }

  String _datePresetLabel(AppString strings, ExplorerDatePreset preset) {
    return switch (preset) {
      ExplorerDatePreset.none => strings.recordsExplorerDateAllKey,
      ExplorerDatePreset.today => strings.recordsExplorerDateTodayKey,
      ExplorerDatePreset.yesterday => strings.recordsExplorerDateYesterdayKey,
      ExplorerDatePreset.thisWeek => strings.recordsExplorerDateThisWeekKey,
      ExplorerDatePreset.thisMonth => strings.recordsExplorerDateThisMonthKey,
      ExplorerDatePreset.lastMonth => strings.recordsExplorerDateLastMonthKey,
      ExplorerDatePreset.custom => strings.recordsExplorerDateCustomKey,
    };
  }

  String _sortLabel(AppString strings, ExplorerSortOption option) {
    return switch (option) {
      ExplorerSortOption.dateDescending =>
        strings.recordsExplorerSortDateDescKey,
      ExplorerSortOption.dateAscending =>
        strings.recordsExplorerSortDateAscKey,
      ExplorerSortOption.amountDescending =>
        strings.recordsExplorerSortAmountDescKey,
      ExplorerSortOption.amountAscending =>
        strings.recordsExplorerSortAmountAscKey,
      ExplorerSortOption.nameAscending => strings.recordsExplorerSortNameAscKey,
    };
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}
