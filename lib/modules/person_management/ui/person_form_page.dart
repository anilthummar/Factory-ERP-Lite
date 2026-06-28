import '../../../../utils/exports.dart';

/// Localized labels for [PersonFormPage] resolved from [AppString].
class PersonFormLabels {
  /// Creates [PersonFormLabels].
  const PersonFormLabels({
    required this.titleAdd,
    required this.titleEdit,
    required this.nameLabel,
    required this.mobileLabel,
    required this.addressLabel,
    required this.notesLabel,
    required this.nameHint,
    required this.mobileHint,
    required this.addressHint,
    required this.notesHint,
    required this.nameRequiredMessage,
    required this.mobileRequiredMessage,
    required this.mobileInvalidMessage,
    required this.saveLabel,
  });

  /// Resolves labels from existing localization keys.
  factory PersonFormLabels.of(AppString strings) {
    return PersonFormLabels(
      titleAdd: strings.addPersonKey,
      titleEdit: strings.editPersonKey,
      nameLabel: strings.nameKey,
      mobileLabel: strings.emailIdKey,
      addressLabel: strings.customerAndLocationKey,
      notesLabel: strings.valuationAndRemarksKey,
      nameHint: strings.writeSomethingKey,
      mobileHint: strings.pleaseEnterEmailIdKey,
      addressHint: strings.writeSomethingKey,
      notesHint: strings.writeSomethingKey,
      nameRequiredMessage: strings.pleaseAddSomethingKey,
      mobileRequiredMessage: strings.pleaseEnterEmailIdKey,
      mobileInvalidMessage: strings.pleaseEnterValidEmailIdKey,
      saveLabel: strings.saveKey,
    );
  }

  /// Screen title in add mode.
  final String titleAdd;

  /// Screen title in edit mode.
  final String titleEdit;

  /// Name field label.
  final String nameLabel;

  /// Mobile field label.
  final String mobileLabel;

  /// Address field label.
  final String addressLabel;

  /// Notes field label.
  final String notesLabel;

  /// Name field hint.
  final String nameHint;

  /// Mobile field hint.
  final String mobileHint;

  /// Address field hint.
  final String addressHint;

  /// Notes field hint.
  final String notesHint;

  /// Validation message when name is empty.
  final String nameRequiredMessage;

  /// Validation message when mobile is empty.
  final String mobileRequiredMessage;

  /// Validation message when mobile format is invalid.
  final String mobileInvalidMessage;

  /// Save button label.
  final String saveLabel;
}

/// Save button callback with validated form values.
typedef PersonFormSubmitCallback = void Function({
  required String name,
  required String mobile,
  String? address,
  String? notes,
});

/// Add / edit person form screen.
class PersonFormPage extends StatefulWidget {
  /// Creates [PersonFormPage].
  const PersonFormPage({
    this.isEdit = false,
    this.initialName,
    this.initialMobile,
    this.initialAddress,
    this.initialNotes,
    this.labels,
    this.onSubmit,
    super.key,
  });

  /// Whether the form is in edit mode.
  final bool isEdit;

  /// Initial name value for edit mode.
  final String? initialName;

  /// Initial mobile value for edit mode.
  final String? initialMobile;

  /// Initial address value for edit mode.
  final String? initialAddress;

  /// Initial notes value for edit mode.
  final String? initialNotes;

  /// Optional localized labels override.
  final PersonFormLabels? labels;

  /// Called with validated form values when save is pressed.
  final PersonFormSubmitCallback? onSubmit;

  @override
  State<PersonFormPage> createState() => _PersonFormPageState();
}

class _PersonFormPageState extends State<PersonFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _mobileController = TextEditingController(text: widget.initialMobile);
    _addressController = TextEditingController(text: widget.initialAddress);
    _notesController = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _validateMobile(String? value, PersonFormLabels labels) {
    return _validateRequired(value, labels.mobileRequiredMessage);
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.hideKeyboard();
      final String address = _addressController.text.trim();
      final String notes = _notesController.text.trim();
      widget.onSubmit?.call(
        name: _nameController.text.trim(),
        mobile: _mobileController.text.trim(),
        address: address.isEmpty ? null : address,
        notes: notes.isEmpty ? null : notes,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PersonFormLabels labels =
        widget.labels ?? PersonFormLabels.of(context.appString);
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
                  validator: (dynamic value) =>
                      _validateRequired(value as String?, labels.nameRequiredMessage),
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
                  title: labels.addressLabel,
                  controller: _addressController,
                  hint: labels.addressHint,
                  maxLines: Dimens.maxLines02,
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
