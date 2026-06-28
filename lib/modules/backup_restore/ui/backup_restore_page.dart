import 'package:file_picker/file_picker.dart';

import '../../../../utils/exports.dart';

/// Backup and restore settings screen.
@RoutePage()
class BackupRestorePage extends StatelessWidget {
  /// Creates [BackupRestorePage].
  const BackupRestorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BackupBloc>(
      create: (BuildContext context) => BackupBloc(
        getBackupOverviewUseCase: getIt<GetBackupOverviewUseCase>(),
        exportLocalJsonBackupUseCase: getIt<ExportLocalJsonBackupUseCase>(),
        validateBackupFileUseCase: getIt<ValidateBackupFileUseCase>(),
        restoreLocalJsonBackupUseCase: getIt<RestoreLocalJsonBackupUseCase>(),
      ),
      child: const _BackupRestoreView(),
    );
  }
}

class _BackupRestoreView extends StatelessWidget {
  const _BackupRestoreView();

  Future<void> _pickBackupFile(BuildContext context) async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['json'],
    );
    if (result == null || result.files.single.path == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    context.read<BackupBloc>().add(
          BackupValidateRequested(result.files.single.path!),
        );
  }

  Future<void> _confirmRestore(BuildContext context, String filePath) async {
    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            final BackupState state = context.read<BackupBloc>().state;
            final BackupValidationResult? validation = state.validation;
            final String summary = validation == null
                ? ''
                : validation.recordCountsByModule.entries
                    .where((MapEntry<String, int> entry) => entry.value > 0)
                    .map(
                      (MapEntry<String, int> entry) =>
                          '${BackupManifest.moduleLabels[entry.key] ?? entry.key}: ${entry.value}',
                    )
                    .join('\n');

            return AlertDialog(
              title: CustomTextLabelWidget(
                label: context.appString.backupRestoreConfirmTitleKey,
              ),
              content: CustomTextLabelWidget(
                label: '${context.appString.backupRestoreConfirmMessageKey}\n\n'
                    '${context.appString.backupRestoreValidationSummaryKey}\n'
                    '${validation?.totalRecords ?? 0} records\n$summary',
                textAlign: TextAlign.start,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: CustomTextLabelWidget(
                    label: context.appString.cancelKey,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: CustomTextLabelWidget(
                    label: context.appString.backupRestoreConfirmActionKey,
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed || !context.mounted) {
      return;
    }

    context.read<BackupBloc>().add(BackupRestoreRequested(filePath));
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.backupRestoreTitleKey,
          textAlign: TextAlign.start,
        ),
      ),
      body: BlocConsumer<BackupBloc, BackupState>(
        listener: (BuildContext context, BackupState state) {
          if (state.status == BackupStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }

          if (state.status == BackupStatus.awaitingConfirmation &&
              state.pendingRestorePath != null) {
            unawaited(_confirmRestore(context, state.pendingRestorePath!));
          }
        },
        builder: (BuildContext context, BackupState state) {
          final bool isBusy = state.status == BackupStatus.loading ||
              state.status == BackupStatus.exporting ||
              state.status == BackupStatus.validating ||
              state.status == BackupStatus.restoring;

          return CustomResponsiveContent(
            child: ListView(
              padding: const EdgeInsets.all(Dimens.padding16),
              children: <Widget>[
                _InfoCard(
                  title: strings.backupRestoreOverviewKey,
                  value: '${state.totalRecords}',
                  subtitle: strings.backupRestoreTotalRecordsKey,
                  icon: Icons.storage_outlined,
                ),
                const SizedBox(height: Dimens.space16),
                if (state.successMessage != null) ...<Widget>[
                  Card(
                    color: colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.padding16),
                      child: CustomTextLabelWidget(
                        label: state.successMessage!,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimens.space16),
                ],
                if (state.progress != null) ...<Widget>[
                  LinearProgressIndicator(value: state.progress!.fraction),
                  const SizedBox(height: Dimens.space8),
                  CustomTextLabelWidget(
                    label: state.progress!.stage,
                    textAlign: TextAlign.start,
                    style: AppStyles.instance.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Dimens.space16),
                ],
                CustomButtonWidget(
                  text: strings.backupRestoreJsonExportKey,
                  backgroundColor: colorScheme.primary,
                  onClick: isBusy
                      ? null
                      : () {
                          context
                              .read<BackupBloc>()
                              .add(const BackupExportRequested());
                        },
                  textStyle:
                      AppStyles.instance.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: Dimens.space12),
                CustomButtonWidget(
                  text: strings.backupRestoreJsonImportKey,
                  backgroundColor: colorScheme.secondaryContainer,
                  onClick: isBusy ? null : () => _pickBackupFile(context),
                  textStyle:
                      AppStyles.instance.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                if (isBusy) ...<Widget>[
                  const SizedBox(height: Dimens.space24),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Card(
      elevation: Dimens.elevation0,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding16),
        child: Row(
          children: <Widget>[
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: Dimens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomTextLabelWidget(
                    label: title,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: Dimens.space4),
                  CustomTextLabelWidget(
                    label: value,
                    style: AppStyles.instance.textTheme.headlineSmall,
                  ),
                  CustomTextLabelWidget(
                    label: subtitle,
                    style: AppStyles.instance.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
