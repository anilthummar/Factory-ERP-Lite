import '../../../../utils/exports.dart';

/// Localized labels for [ExpenseFilterBottomSheet].
class ExpenseFilterUiConfig {
  /// Creates [ExpenseFilterUiConfig].
  const ExpenseFilterUiConfig({
    required this.title,
    required this.fromDateLabel,
    required this.toDateLabel,
    required this.applyLabel,
    required this.clearLabel,
  });

  /// Resolves filter labels from localization.
  factory ExpenseFilterUiConfig.of(AppString strings) {
    return ExpenseFilterUiConfig(
      title: strings.filterKey,
      fromDateLabel: strings.dateKey,
      toDateLabel: strings.dateKey,
      applyLabel: strings.applyFilterKey,
      clearLabel: strings.clearFilterKey,
    );
  }

  final String title;
  final String fromDateLabel;
  final String toDateLabel;
  final String applyLabel;
  final String clearLabel;
}

/// Filter bottom sheet placeholder for expense list screens.
class ExpenseFilterBottomSheet extends StatefulWidget {
  /// Creates [ExpenseFilterBottomSheet].
  const ExpenseFilterBottomSheet({
    required this.config,
    this.onApply,
    this.onClear,
    super.key,
  });

  /// Filter UI labels.
  final ExpenseFilterUiConfig config;

  /// Apply filter callback placeholder.
  final VoidCallback? onApply;

  /// Clear filter callback placeholder.
  final VoidCallback? onClear;

  /// Shows the filter bottom sheet.
  static Future<void> show({
    required BuildContext context,
    ExpenseFilterUiConfig? config,
    VoidCallback? onApply,
    VoidCallback? onClear,
  }) {
    final ExpenseFilterUiConfig resolvedConfig =
        config ?? ExpenseFilterUiConfig.of(context.appString);

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
        return ExpenseFilterBottomSheet(
          config: resolvedConfig,
          onApply: onApply,
          onClear: onClear,
        );
      },
    );
  }

  @override
  State<ExpenseFilterBottomSheet> createState() =>
      _ExpenseFilterBottomSheetState();
}

class _ExpenseFilterBottomSheetState extends State<ExpenseFilterBottomSheet> {
  late final TextEditingController _fromDateController;
  late final TextEditingController _toDateController;

  @override
  void initState() {
    super.initState();
    _fromDateController = TextEditingController();
    _toDateController = TextEditingController();
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
    final ExpenseFilterUiConfig config = widget.config;

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
