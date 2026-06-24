import '../../../../utils/exports.dart';

/// Localized labels for [FactoryStatusChangePage].
class FactoryStatusChangeLabels {
  /// Creates [FactoryStatusChangeLabels].
  const FactoryStatusChangeLabels({
    required this.title,
    required this.statusLabel,
    required this.notesLabel,
    required this.notesHint,
    required this.statusRequiredMessage,
    required this.saveLabel,
  });

  /// Resolves labels from localization keys.
  factory FactoryStatusChangeLabels.of(AppString strings) {
    return FactoryStatusChangeLabels(
      title: strings.changeFactoryStatusKey,
      statusLabel: strings.selectFactoryStatusKey,
      notesLabel: strings.factoryStatusNotesKey,
      notesHint: strings.writeSomethingKey,
      statusRequiredMessage: strings.factoryStatusRequiredKey,
      saveLabel: strings.saveKey,
    );
  }

  final String title;
  final String statusLabel;
  final String notesLabel;
  final String notesHint;
  final String statusRequiredMessage;
  final String saveLabel;
}

/// Change factory status form screen (UI only).
class FactoryStatusChangePage extends StatefulWidget {
  /// Creates [FactoryStatusChangePage].
  const FactoryStatusChangePage({
    this.initialStatus,
    this.initialNotes,
    this.labels,
    this.onSave,
    super.key,
  });

  /// Pre-selected status.
  final FactoryStatusType? initialStatus;

  /// Pre-filled notes.
  final String? initialNotes;

  /// Optional localized labels override.
  final FactoryStatusChangeLabels? labels;

  /// Save callback placeholder.
  final VoidCallback? onSave;

  @override
  State<FactoryStatusChangePage> createState() =>
      _FactoryStatusChangePageState();
}

class _FactoryStatusChangePageState extends State<FactoryStatusChangePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _notesController;
  FactoryStatusType? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.initialNotes);
    _selectedStatus = widget.initialStatus;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.hideKeyboard();
      widget.onSave?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final FactoryStatusChangeLabels labels =
        widget.labels ?? FactoryStatusChangeLabels.of(context.appString);
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: labels.title,
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
              _StatusSelectorField(
                title: labels.statusLabel,
                strings: strings,
                initialValue: _selectedStatus,
                requiredMessage: labels.statusRequiredMessage,
                onChanged: (FactoryStatusType? value) {
                  setState(() => _selectedStatus = value);
                },
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

class _StatusSelectorField extends FormField<FactoryStatusType> {
  _StatusSelectorField({
    required String title,
    required AppString strings,
    required String requiredMessage,
    required ValueChanged<FactoryStatusType?> onChanged,
    FactoryStatusType? initialValue,
  }) : super(
          initialValue: initialValue,
          validator: (FactoryStatusType? value) {
            if (value == null) {
              return requiredMessage;
            }
            return null;
          },
          builder: (FormFieldState<FactoryStatusType> field) {
            final ColorScheme colorScheme = field.context.theme.colorScheme;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomTextLabelWidget(
                  label: title,
                  textAlign: TextAlign.start,
                  style: AppStyles.instance.textTheme.labelSmall,
                ),
                const SizedBox(height: Dimens.space12),
                ...kFactoryStatusTypes.map((FactoryStatusType status) {
                  final bool isSelected = field.value == status;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.space8),
                    child: Material(
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(Dimens.radius12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(Dimens.radius12),
                        onTap: () {
                          field.didChange(status);
                          onChanged(status);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(Dimens.padding16),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                status.icon,
                                color: isSelected
                                    ? colorScheme.onPrimaryContainer
                                    : status.foregroundColor(colorScheme),
                              ),
                              const SizedBox(width: Dimens.space12),
                              Expanded(
                                child: CustomTextLabelWidget(
                                  label: status.label(strings),
                                  textAlign: TextAlign.start,
                                  style: AppStyles.instance.textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (field.errorText != null) ...<Widget>[
                  const SizedBox(height: Dimens.space4),
                  CustomTextLabelWidget(
                    label: field.errorText!,
                    textAlign: TextAlign.start,
                    style: AppStyles.instance.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ],
            );
          },
        );
}
