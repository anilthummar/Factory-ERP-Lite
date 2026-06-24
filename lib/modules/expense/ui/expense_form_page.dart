import '../../../../utils/exports.dart';

/// Localized configuration for [ExpenseFormPage].
class ExpenseFormUiConfig {
  /// Creates [ExpenseFormUiConfig].
  const ExpenseFormUiConfig({
    required this.pageTitleAdd,
    required this.pageTitleEdit,
    required this.titleLabel,
    required this.amountLabel,
    required this.dateLabel,
    required this.notesLabel,
    required this.attachmentLabel,
    required this.addAttachmentLabel,
    required this.titleHint,
    required this.amountHint,
    required this.dateHint,
    required this.notesHint,
    required this.titleRequiredMessage,
    required this.amountRequiredMessage,
    required this.dateRequiredMessage,
    required this.saveLabel,
  });

  /// Builds shared expense form labels; titles are module-specific.
  factory ExpenseFormUiConfig.of(
    AppString strings, {
    required String pageTitleAdd,
    String? pageTitleEdit,
  }) {
    return ExpenseFormUiConfig(
      pageTitleAdd: pageTitleAdd,
      pageTitleEdit: pageTitleEdit ?? pageTitleAdd,
      titleLabel: strings.expenseTitleKey,
      amountLabel: strings.amountKey,
      dateLabel: strings.dateKey,
      notesLabel: strings.valuationAndRemarksKey,
      attachmentLabel: strings.attachmentKey,
      addAttachmentLabel: strings.addAttachmentKey,
      titleHint: strings.writeSomethingKey,
      amountHint: strings.writeSomethingKey,
      dateHint: strings.writeSomethingKey,
      notesHint: strings.writeSomethingKey,
      titleRequiredMessage: strings.expenseTitleRequiredKey,
      amountRequiredMessage: strings.expenseAmountRequiredKey,
      dateRequiredMessage: strings.expenseDateRequiredKey,
      saveLabel: strings.saveKey,
    );
  }

  final String pageTitleAdd;
  final String pageTitleEdit;
  final String titleLabel;
  final String amountLabel;
  final String dateLabel;
  final String notesLabel;
  final String attachmentLabel;
  final String addAttachmentLabel;
  final String titleHint;
  final String amountHint;
  final String dateHint;
  final String notesHint;
  final String titleRequiredMessage;
  final String amountRequiredMessage;
  final String dateRequiredMessage;
  final String saveLabel;
}

/// Reusable expense add/edit form for all expense modules.
class ExpenseFormPage extends StatefulWidget {
  /// Creates [ExpenseFormPage].
  const ExpenseFormPage({
    required this.config,
    this.isEdit = false,
    this.initialTitle,
    this.initialAmount,
    this.initialDate,
    this.initialNotes,
    this.onSave,
    this.onAddAttachment,
    super.key,
  });

  /// Localized UI configuration.
  final ExpenseFormUiConfig config;

  /// Whether the form is in edit mode.
  final bool isEdit;

  /// Initial title value.
  final String? initialTitle;

  /// Initial amount value.
  final String? initialAmount;

  /// Initial date value.
  final String? initialDate;

  /// Initial notes value.
  final String? initialNotes;

  /// Save button callback placeholder.
  final VoidCallback? onSave;

  /// Attachment action callback placeholder.
  final VoidCallback? onAddAttachment;

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _dateController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _amountController = TextEditingController(text: widget.initialAmount);
    _dateController = TextEditingController(text: widget.initialDate);
    _notesController = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.hideKeyboard();
      widget.onSave?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseFormUiConfig config = widget.config;
    final ColorScheme colorScheme = context.theme.colorScheme;
    final String title =
        widget.isEdit ? config.pageTitleEdit : config.pageTitleAdd;

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
                title: config.titleLabel,
                controller: _titleController,
                hint: config.titleHint,
                validator: (dynamic value) => _validateRequired(
                  value as String?,
                  config.titleRequiredMessage,
                ),
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: config.amountLabel,
                controller: _amountController,
                hint: config.amountHint,
                validator: (dynamic value) => _validateRequired(
                  value as String?,
                  config.amountRequiredMessage,
                ),
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: config.dateLabel,
                controller: _dateController,
                hint: config.dateHint,
                readOnly: true,
                validator: (dynamic value) => _validateRequired(
                  value as String?,
                  config.dateRequiredMessage,
                ),
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: config.notesLabel,
                controller: _notesController,
                hint: config.notesHint,
                maxLines: Dimens.maxLines03,
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextLabelWidget(
                label: config.attachmentLabel,
                textAlign: TextAlign.start,
                style: AppStyles.instance.textTheme.labelSmall,
              ),
              const SizedBox(height: Dimens.space10),
              OutlinedButton.icon(
                onPressed: widget.onAddAttachment,
                icon: const Icon(Icons.attach_file_outlined),
                label: CustomTextLabelWidget(
                  label: config.addAttachmentLabel,
                  style: AppStyles.instance.textTheme.labelMedium,
                ),
              ),
              const SizedBox(height: Dimens.space32),
              CustomButtonWidget(
                text: config.saveLabel,
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
