import '../../../../utils/exports.dart';
import 'widget/recurring_expense_frequency.dart';

/// Localized labels for [RecurringExpenseFormPage].
class RecurringExpenseFormLabels {
  /// Creates [RecurringExpenseFormLabels].
  const RecurringExpenseFormLabels({
    required this.titleAdd,
    required this.titleEdit,
    required this.titleLabel,
    required this.amountLabel,
    required this.frequencyLabel,
    required this.startDateLabel,
    required this.endDateLabel,
    required this.notesLabel,
    required this.titleHint,
    required this.amountHint,
    required this.startDateHint,
    required this.endDateHint,
    required this.notesHint,
    required this.frequencyHint,
    required this.titleRequiredMessage,
    required this.amountRequiredMessage,
    required this.frequencyRequiredMessage,
    required this.startDateRequiredMessage,
    required this.saveLabel,
  });

  /// Resolves labels from localization keys.
  factory RecurringExpenseFormLabels.of(AppString strings) {
    return RecurringExpenseFormLabels(
      titleAdd: strings.addRecurringExpenseKey,
      titleEdit: strings.editRecurringExpenseKey,
      titleLabel: strings.expenseTitleKey,
      amountLabel: strings.amountKey,
      frequencyLabel: strings.frequencyKey,
      startDateLabel: strings.startDateKey,
      endDateLabel: strings.endDateOptionalKey,
      notesLabel: strings.valuationAndRemarksKey,
      titleHint: strings.writeSomethingKey,
      amountHint: strings.writeSomethingKey,
      startDateHint: strings.selectDateKey,
      endDateHint: strings.selectDateKey,
      notesHint: strings.writeSomethingKey,
      frequencyHint: strings.writeSomethingKey,
      titleRequiredMessage: strings.expenseTitleRequiredKey,
      amountRequiredMessage: strings.expenseAmountRequiredKey,
      frequencyRequiredMessage: strings.recurringExpenseFrequencyRequiredKey,
      startDateRequiredMessage: strings.recurringExpenseStartDateRequiredKey,
      saveLabel: strings.saveKey,
    );
  }

  final String titleAdd;
  final String titleEdit;
  final String titleLabel;
  final String amountLabel;
  final String frequencyLabel;
  final String startDateLabel;
  final String endDateLabel;
  final String notesLabel;
  final String titleHint;
  final String amountHint;
  final String startDateHint;
  final String endDateHint;
  final String notesHint;
  final String frequencyHint;
  final String titleRequiredMessage;
  final String amountRequiredMessage;
  final String frequencyRequiredMessage;
  final String startDateRequiredMessage;
  final String saveLabel;
}

/// Save callback with validated recurring expense form values.
typedef RecurringExpenseFormSubmitCallback = void Function({
  required String title,
  required double amount,
  required RecurringExpenseFrequency frequency,
  required DateTime startDate,
  DateTime? endDate,
  String? notes,
});

/// Add / edit recurring expense form screen.
class RecurringExpenseFormPage extends StatefulWidget {
  /// Creates [RecurringExpenseFormPage].
  const RecurringExpenseFormPage({
    this.isEdit = false,
    this.initialTitle,
    this.initialAmount,
    this.initialFrequency,
    this.initialStartDate,
    this.initialEndDate,
    this.initialNotes,
    this.labels,
    this.onSave,
    this.onSubmit,
    super.key,
  });

  /// Whether the form is in edit mode.
  final bool isEdit;

  /// Initial title value.
  final String? initialTitle;

  /// Initial amount value.
  final String? initialAmount;

  /// Initial frequency selection.
  final RecurringExpenseFrequency? initialFrequency;

  /// Initial start date value.
  final String? initialStartDate;

  /// Initial end date value.
  final String? initialEndDate;

  /// Initial notes value.
  final String? initialNotes;

  /// Optional localized labels override.
  final RecurringExpenseFormLabels? labels;

  /// Save button callback placeholder.
  final VoidCallback? onSave;

  /// Called with validated form values when save is pressed.
  final RecurringExpenseFormSubmitCallback? onSubmit;

  @override
  State<RecurringExpenseFormPage> createState() =>
      _RecurringExpenseFormPageState();
}

class _RecurringExpenseFormPageState extends State<RecurringExpenseFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _notesController;

  RecurringExpenseFrequency? _selectedFrequency;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _amountController = TextEditingController(text: widget.initialAmount);
    _startDateController =
        TextEditingController(text: widget.initialStartDate);
    _endDateController = TextEditingController(text: widget.initialEndDate);
    _notesController = TextEditingController(text: widget.initialNotes);
    _selectedFrequency = widget.initialFrequency;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  Future<void> _pickStartDate() async {
    await pickAppDateIntoController(context, _startDateController);
  }

  Future<void> _pickEndDate() async {
    await pickAppDateIntoController(
      context,
      _endDateController,
      firstDate: _startDateController.text.trim().isEmpty
          ? null
          : stringToDate(_startDateController.text.trim()),
    );
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedFrequency == null) {
        return;
      }
      context.hideKeyboard();
      final String notes = _notesController.text.trim();
      final String endDateText = _endDateController.text.trim();
      widget.onSubmit?.call(
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        frequency: _selectedFrequency!,
        startDate: stringToDate(_startDateController.text.trim()),
        endDate: endDateText.isEmpty ? null : stringToDate(endDateText),
        notes: notes.isEmpty ? null : notes,
      );
      widget.onSave?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final RecurringExpenseFormLabels labels =
        widget.labels ?? RecurringExpenseFormLabels.of(context.appString);
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;
    final String title =
        widget.isEdit ? labels.titleEdit : labels.titleAdd;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: title,
          textAlign: TextAlign.start,
        ),
      ),
      body: CustomResponsiveContent(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              Dimens.padding16,
              Dimens.padding8,
              Dimens.padding16,
              Dimens.padding16,
            ),
            children: <Widget>[
              CustomTextFormFieldWithLabelWidget(
                title: labels.titleLabel,
                controller: _titleController,
                hint: labels.titleHint,
                validator: (dynamic value) => _validateRequired(
                  value as String?,
                  labels.titleRequiredMessage,
                ),
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: labels.amountLabel,
                controller: _amountController,
                hint: labels.amountHint,
                textInputType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: FormInputUtils.decimalAmountFormatters,
                validator: (dynamic value) => FormInputUtils.validateAmount(
                  value as String?,
                  requiredMessage: labels.amountRequiredMessage,
                  invalidMessage: strings.expenseAmountInvalidKey,
                ),
              ),
              const SizedBox(height: Dimens.space16),
              _FrequencyField(
                title: labels.frequencyLabel,
                hint: labels.frequencyHint,
                initialValue: _selectedFrequency,
                strings: strings,
                requiredMessage: labels.frequencyRequiredMessage,
                onChanged: (RecurringExpenseFrequency? value) {
                  setState(() => _selectedFrequency = value);
                },
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: labels.startDateLabel,
                controller: _startDateController,
                hint: labels.startDateHint,
                readOnly: true,
                onTap: _pickStartDate,
                validator: (dynamic value) => FormInputUtils.validateRequired(
                  value as String?,
                  labels.startDateRequiredMessage,
                ),
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: labels.endDateLabel,
                controller: _endDateController,
                hint: labels.endDateHint,
                readOnly: true,
                onTap: _pickEndDate,
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: labels.notesLabel,
                controller: _notesController,
                hint: labels.notesHint,
                maxLines: Dimens.maxLines03,
              ),
              const SizedBox(height: Dimens.space32),
              CustomButtonWidget(
                text: labels.saveLabel,
                backgroundColor: colorScheme.primary,
                onClick: _handleSave,
                textStyle: AppStyles.instance.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FrequencyField extends FormField<RecurringExpenseFrequency> {
  _FrequencyField({
    required String title,
    required String hint,
    required AppString strings,
    required String requiredMessage,
    required ValueChanged<RecurringExpenseFrequency?> onChanged,
    super.initialValue,
  }) : super(
          validator: (RecurringExpenseFrequency? value) {
            if (value == null) {
              return requiredMessage;
            }
            return null;
          },
          builder: (FormFieldState<RecurringExpenseFrequency> field) {
            final ColorScheme colorScheme =
                field.context.theme.colorScheme;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomTextLabelWidget(
                  label: title,
                  textAlign: TextAlign.start,
                  style: AppStyles.instance.textTheme.labelSmall,
                ),
                const SizedBox(height: Dimens.space10),
                DropdownButtonFormField<RecurringExpenseFrequency>(
                  initialValue: field.value,
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: hint,
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.4),
                    errorText: field.errorText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimens.radius8),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimens.radius8),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimens.radius8),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Dimens.padding16,
                      vertical: Dimens.padding14,
                    ),
                  ),
                  items: kRecurringExpenseFrequencies
                      .map((RecurringExpenseFrequency frequency) {
                    return DropdownMenuItem<RecurringExpenseFrequency>(
                      value: frequency,
                      child: CustomTextLabelWidget(
                        label: frequency.label(strings),
                      ),
                    );
                  }).toList(),
                  onChanged: (RecurringExpenseFrequency? value) {
                    field.didChange(value);
                    onChanged(value);
                  },
                ),
              ],
            );
          },
        );
}
