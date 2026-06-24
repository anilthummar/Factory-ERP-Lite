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
    required this.amountInvalidMessage,
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
      dateHint: strings.selectDateKey,
      notesHint: strings.writeSomethingKey,
      titleRequiredMessage: strings.expenseTitleRequiredKey,
      amountRequiredMessage: strings.expenseAmountRequiredKey,
      amountInvalidMessage: strings.expenseAmountInvalidKey,
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
  final String amountInvalidMessage;
  final String dateRequiredMessage;
  final String saveLabel;
}

/// Save callback with validated expense form values.
typedef ExpenseFormSubmitCallback = void Function({
  required String title,
  required double amount,
  required DateTime date,
  String? notes,
  String? attachmentPath,
});

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
    this.initialAttachmentPath,
    this.onSubmit,
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

  /// Initial attachment file path.
  final String? initialAttachmentPath;

  /// Called with validated values when save succeeds.
  final ExpenseFormSubmitCallback? onSubmit;

  /// Legacy save callback when [onSubmit] is not provided.
  final VoidCallback? onSave;

  /// Optional custom attachment handler.
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

  String? _attachmentPath;
  String? _attachmentName;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _amountController = TextEditingController(text: widget.initialAmount);
    _dateController = TextEditingController(text: widget.initialDate);
    _notesController = TextEditingController(text: widget.initialNotes);
    _attachmentPath = widget.initialAttachmentPath;
    if (_attachmentPath != null) {
      _attachmentName = _attachmentPath!.split('/').last;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    await pickAppDateIntoController(context, _dateController);
  }

  Future<void> _pickAttachment() async {
    if (widget.onAddAttachment != null) {
      widget.onAddAttachment!.call();
      return;
    }

    try {
      final AttachmentEntity? attachment =
          await getIt<PickAndSaveAttachmentUseCase>().pickAndSave(
        attachmentType: AttachmentType.receipt,
      );
      if (!mounted || attachment == null) {
        return;
      }

      setState(() {
        _attachmentPath = attachment.localPath;
        _attachmentName = attachment.fileName;
      });
    } on UnsupportedAttachmentTypeException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomTextLabelWidget(
            label: context.appString.unsupportedAttachmentTypeKey,
          ),
        ),
      );
    } on Object catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomTextLabelWidget(label: error.toString()),
        ),
      );
    }
  }

  void _removeAttachment() {
    setState(() {
      _attachmentPath = null;
      _attachmentName = null;
    });
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.hideKeyboard();
      final ExpenseFormSubmitCallback? onSubmit = widget.onSubmit;
      if (onSubmit != null) {
        onSubmit(
          title: _titleController.text.trim(),
          amount: double.parse(_amountController.text.trim()),
          date: stringToDate(_dateController.text.trim()),
          notes: _nullableText(_notesController.text),
          attachmentPath: _attachmentPath,
        );
      } else {
        widget.onSave?.call();
      }
    }
  }

  String? _nullableText(String value) {
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
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
                validator: (dynamic value) => FormInputUtils.validateRequired(
                  value as String?,
                  config.titleRequiredMessage,
                ),
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: config.amountLabel,
                controller: _amountController,
                hint: config.amountHint,
                textInputType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: FormInputUtils.decimalAmountFormatters,
                validator: (dynamic value) => FormInputUtils.validateAmount(
                  value as String?,
                  requiredMessage: config.amountRequiredMessage,
                  invalidMessage: config.amountInvalidMessage,
                ),
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: config.dateLabel,
                controller: _dateController,
                hint: config.dateHint,
                readOnly: true,
                onTap: _pickDate,
                validator: (dynamic value) => FormInputUtils.validateRequired(
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
                onPressed: _pickAttachment,
                icon: const Icon(Icons.attach_file_outlined),
                label: CustomTextLabelWidget(
                  label: config.addAttachmentLabel,
                  style: AppStyles.instance.textTheme.labelMedium,
                ),
              ),
              if (_attachmentName != null) ...<Widget>[
                const SizedBox(height: Dimens.space8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.insert_drive_file_outlined),
                  title: CustomTextLabelWidget(
                    label: _attachmentName!,
                    maxLines: Dimens.maxLines01,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _removeAttachment,
                  ),
                ),
              ],
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
