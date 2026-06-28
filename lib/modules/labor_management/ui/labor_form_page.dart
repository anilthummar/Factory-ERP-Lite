import '../../../../utils/exports.dart';

/// Localized labels for [LaborFormPage] resolved from [AppString].
class LaborFormLabels {
  /// Creates [LaborFormLabels].
  const LaborFormLabels({
    required this.titleAdd,
    required this.titleEdit,
    required this.nameLabel,
    required this.mobileLabel,
    required this.skillLabel,
    required this.dailyWageLabel,
    required this.notesLabel,
    required this.nameHint,
    required this.mobileHint,
    required this.skillHint,
    required this.dailyWageHint,
    required this.notesHint,
    required this.nameRequiredMessage,
    required this.mobileRequiredMessage,
    required this.mobileInvalidMessage,
    required this.skillRequiredMessage,
    required this.dailyWageRequiredMessage,
    required this.saveLabel,
  });

  /// Resolves labels from localization keys.
  factory LaborFormLabels.of(AppString strings) {
    return LaborFormLabels(
      titleAdd: strings.addLaborKey,
      titleEdit: strings.addLaborKey,
      nameLabel: strings.nameKey,
      mobileLabel: strings.emailIdKey,
      skillLabel: strings.laborSkillKey,
      dailyWageLabel: strings.dailyWageKey,
      notesLabel: strings.valuationAndRemarksKey,
      nameHint: strings.writeSomethingKey,
      mobileHint: strings.pleaseEnterEmailIdKey,
      skillHint: strings.writeSomethingKey,
      dailyWageHint: strings.writeSomethingKey,
      notesHint: strings.writeSomethingKey,
      nameRequiredMessage: strings.pleaseAddSomethingKey,
      mobileRequiredMessage: strings.pleaseEnterEmailIdKey,
      mobileInvalidMessage: strings.pleaseEnterValidEmailIdKey,
      skillRequiredMessage: strings.pleaseAddSomethingKey,
      dailyWageRequiredMessage: strings.pleaseAddSomethingKey,
      saveLabel: strings.saveKey,
    );
  }

  final String titleAdd;
  final String titleEdit;
  final String nameLabel;
  final String mobileLabel;
  final String skillLabel;
  final String dailyWageLabel;
  final String notesLabel;
  final String nameHint;
  final String mobileHint;
  final String skillHint;
  final String dailyWageHint;
  final String notesHint;
  final String nameRequiredMessage;
  final String mobileRequiredMessage;
  final String mobileInvalidMessage;
  final String skillRequiredMessage;
  final String dailyWageRequiredMessage;
  final String saveLabel;
}

/// Save callback with validated labor form values.
typedef LaborFormSubmitCallback = void Function({
  required String name,
  required String mobile,
  required String skill,
  required double dailyWage,
  String? notes,
});

/// Add / edit labor form screen.
class LaborFormPage extends StatefulWidget {
  const LaborFormPage({
    this.isEdit = false,
    this.initialName,
    this.initialMobile,
    this.initialSkill,
    this.initialDailyWage,
    this.initialNotes,
    this.labels,
    this.onSubmit,
    super.key,
  });

  final bool isEdit;
  final String? initialName;
  final String? initialMobile;
  final String? initialSkill;
  final String? initialDailyWage;
  final String? initialNotes;
  final LaborFormLabels? labels;
  final LaborFormSubmitCallback? onSubmit;

  @override
  State<LaborFormPage> createState() => _LaborFormPageState();
}

class _LaborFormPageState extends State<LaborFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _skillController;
  late final TextEditingController _dailyWageController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _mobileController = TextEditingController(text: widget.initialMobile);
    _skillController = TextEditingController(text: widget.initialSkill);
    _dailyWageController = TextEditingController(text: widget.initialDailyWage);
    _notesController = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _skillController.dispose();
    _dailyWageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _validateMobile(String? value, LaborFormLabels labels) {
    return FormInputUtils.validateRequired(
      value,
      labels.mobileRequiredMessage,
    );
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.hideKeyboard();
      final String notes = _notesController.text.trim();
      widget.onSubmit?.call(
        name: _nameController.text.trim(),
        mobile: _mobileController.text.trim(),
        skill: _skillController.text.trim(),
        dailyWage: double.parse(_dailyWageController.text.trim()),
        notes: notes.isEmpty ? null : notes,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final LaborFormLabels labels =
        widget.labels ?? LaborFormLabels.of(context.appString);
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
                title: labels.nameLabel,
                controller: _nameController,
                hint: labels.nameHint,
                validator: (dynamic value) => _validateRequired(
                  value as String?,
                  labels.nameRequiredMessage,
                ),
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: labels.mobileLabel,
                controller: _mobileController,
                hint: labels.mobileHint,
                validator: (dynamic value) =>
                    _validateMobile(value as String?, labels),
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: labels.skillLabel,
                controller: _skillController,
                hint: labels.skillHint,
                validator: (dynamic value) => _validateRequired(
                  value as String?,
                  labels.skillRequiredMessage,
                ),
              ),
              const SizedBox(height: Dimens.space16),
              CustomTextFormFieldWithLabelWidget(
                title: labels.dailyWageLabel,
                controller: _dailyWageController,
                hint: labels.dailyWageHint,
                textInputType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: FormInputUtils.decimalAmountFormatters,
                validator: (dynamic value) => FormInputUtils.validateAmount(
                  value as String?,
                  requiredMessage: labels.dailyWageRequiredMessage,
                  invalidMessage: context.appString.expenseAmountInvalidKey,
                ),
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
