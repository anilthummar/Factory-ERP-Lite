import '../../../../utils/exports.dart';

/// Localized option for report category filters.
class ReportCategoryOption {
  /// Creates [ReportCategoryOption].
  const ReportCategoryOption({
    required this.id,
    required this.label,
  });

  /// Unique category identifier.
  final String id;

  /// Display label.
  final String label;
}

/// Localized configuration for [ReportFilterBottomSheet].
class ReportFilterUiConfig {
  /// Creates [ReportFilterUiConfig].
  const ReportFilterUiConfig({
    required this.title,
    required this.fromDateLabel,
    required this.toDateLabel,
    required this.categoryLabel,
    required this.allCategoriesLabel,
    required this.applyLabel,
    required this.clearLabel,
    required this.categories,
  });

  /// Builds expense report filter labels.
  factory ReportFilterUiConfig.expense(AppString strings) {
    return ReportFilterUiConfig(
      title: strings.filterKey,
      fromDateLabel: strings.reportFromDateKey,
      toDateLabel: strings.reportToDateKey,
      categoryLabel: strings.reportCategoryKey,
      allCategoriesLabel: strings.reportAllCategoriesKey,
      applyLabel: strings.applyFilterKey,
      clearLabel: strings.clearFilterKey,
      categories: <ReportCategoryOption>[
        ReportCategoryOption(
          id: 'all',
          label: strings.reportAllCategoriesKey,
        ),
        ReportCategoryOption(
          id: 'material',
          label: strings.materialPurchaseKey,
        ),
        ReportCategoryOption(
          id: 'truck',
          label: strings.truckExpensesKey,
        ),
        ReportCategoryOption(
          id: 'maintenance',
          label: strings.maintenanceExpensesKey,
        ),
        ReportCategoryOption(
          id: 'electricity',
          label: strings.electricityExpensesKey,
        ),
        ReportCategoryOption(
          id: 'misc',
          label: strings.miscExpensesKey,
        ),
        ReportCategoryOption(
          id: 'recurring',
          label: strings.recurringExpensesKey,
        ),
      ],
    );
  }

  /// Builds labor report filter labels.
  factory ReportFilterUiConfig.labor(AppString strings) {
    return ReportFilterUiConfig(
      title: strings.filterKey,
      fromDateLabel: strings.reportFromDateKey,
      toDateLabel: strings.reportToDateKey,
      categoryLabel: strings.reportCategoryKey,
      allCategoriesLabel: strings.reportAllCategoriesKey,
      applyLabel: strings.applyFilterKey,
      clearLabel: strings.clearFilterKey,
      categories: <ReportCategoryOption>[
        ReportCategoryOption(
          id: 'all',
          label: strings.reportAllCategoriesKey,
        ),
        ReportCategoryOption(
          id: 'skilled',
          label: strings.laborSkillKey,
        ),
        ReportCategoryOption(
          id: 'wage',
          label: strings.dailyWageKey,
        ),
      ],
    );
  }

  /// Builds person report filter labels.
  factory ReportFilterUiConfig.person(AppString strings) {
    return ReportFilterUiConfig(
      title: strings.filterKey,
      fromDateLabel: strings.reportFromDateKey,
      toDateLabel: strings.reportToDateKey,
      categoryLabel: strings.reportCategoryKey,
      allCategoriesLabel: strings.reportAllCategoriesKey,
      applyLabel: strings.applyFilterKey,
      clearLabel: strings.clearFilterKey,
      categories: <ReportCategoryOption>[
        ReportCategoryOption(
          id: 'all',
          label: strings.reportAllCategoriesKey,
        ),
        ReportCategoryOption(
          id: 'active',
          label: strings.personManagementKey,
        ),
      ],
    );
  }

  /// Builds monthly summary filter labels.
  factory ReportFilterUiConfig.monthly(AppString strings) {
    return ReportFilterUiConfig(
      title: strings.filterKey,
      fromDateLabel: strings.reportFromDateKey,
      toDateLabel: strings.reportToDateKey,
      categoryLabel: strings.reportCategoryKey,
      allCategoriesLabel: strings.reportAllCategoriesKey,
      applyLabel: strings.applyFilterKey,
      clearLabel: strings.clearFilterKey,
      categories: <ReportCategoryOption>[
        ReportCategoryOption(
          id: 'all',
          label: strings.reportAllCategoriesKey,
        ),
        ReportCategoryOption(
          id: 'expenses',
          label: strings.totalExpensesKey,
        ),
        ReportCategoryOption(
          id: 'labor',
          label: strings.activeLaborKey,
        ),
        ReportCategoryOption(
          id: 'materials',
          label: strings.materialsKey,
        ),
      ],
    );
  }

  final String title;
  final String fromDateLabel;
  final String toDateLabel;
  final String categoryLabel;
  final String allCategoriesLabel;
  final String applyLabel;
  final String clearLabel;
  final List<ReportCategoryOption> categories;
}

/// Report filter bottom sheet with date range and category (UI only).
class ReportFilterBottomSheet extends StatefulWidget {
  /// Creates [ReportFilterBottomSheet].
  const ReportFilterBottomSheet({
    required this.config,
    this.onApply,
    this.onClear,
    super.key,
  });

  /// Filter UI configuration.
  final ReportFilterUiConfig config;

  /// Apply filter callback placeholder.
  final VoidCallback? onApply;

  /// Clear filter callback placeholder.
  final VoidCallback? onClear;

  /// Shows the report filter bottom sheet.
  static Future<void> show({
    required BuildContext context,
    required ReportFilterUiConfig config,
    VoidCallback? onApply,
    VoidCallback? onClear,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimens.radius12),
        ),
      ),
      builder: (BuildContext context) {
        return ReportFilterBottomSheet(
          config: config,
          onApply: onApply,
          onClear: onClear,
        );
      },
    );
  }

  @override
  State<ReportFilterBottomSheet> createState() =>
      _ReportFilterBottomSheetState();
}

class _ReportFilterBottomSheetState extends State<ReportFilterBottomSheet> {
  late final TextEditingController _fromDateController;
  late final TextEditingController _toDateController;
  String _selectedCategoryId = 'all';

  @override
  void initState() {
    super.initState();
    _fromDateController = TextEditingController();
    _toDateController = TextEditingController();
    _selectedCategoryId = widget.config.categories.first.id;
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    final ReportFilterUiConfig config = widget.config;

    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.padding16,
        right: Dimens.padding16,
        top: Dimens.padding16,
        bottom: MediaQuery.paddingOf(context).bottom + Dimens.padding16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomTextLabelWidget(
            label: config.title,
            textAlign: TextAlign.start,
            style: AppStyles.instance.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: Dimens.space16),
          CustomTextFormFieldWithLabelWidget(
            title: config.fromDateLabel,
            controller: _fromDateController,
            hint: context.appString.writeSomethingKey,
            readOnly: true,
          ),
          const SizedBox(height: Dimens.space16),
          CustomTextFormFieldWithLabelWidget(
            title: config.toDateLabel,
            controller: _toDateController,
            hint: context.appString.writeSomethingKey,
            readOnly: true,
          ),
          const SizedBox(height: Dimens.space16),
          CustomTextLabelWidget(
            label: config.categoryLabel,
            textAlign: TextAlign.start,
            style: AppStyles.instance.textTheme.labelSmall,
          ),
          const SizedBox(height: Dimens.space10),
          Wrap(
            spacing: Dimens.space8,
            runSpacing: Dimens.space8,
            children: config.categories.map((ReportCategoryOption option) {
              final bool isSelected = _selectedCategoryId == option.id;

              return FilterChip(
                label: CustomTextLabelWidget(label: option.label),
                selected: isSelected,
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() => _selectedCategoryId = option.id);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: Dimens.space24),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomButtonWidget(
                  text: config.clearLabel,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  onClick: () {
                    widget.onClear?.call();
                    Navigator.of(context).pop();
                  },
                  textStyle: AppStyles.instance.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: Dimens.space12),
              Expanded(
                child: CustomButtonWidget(
                  text: config.applyLabel,
                  backgroundColor: colorScheme.primary,
                  onClick: () {
                    widget.onApply?.call();
                    Navigator.of(context).pop();
                  },
                  textStyle: AppStyles.instance.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
