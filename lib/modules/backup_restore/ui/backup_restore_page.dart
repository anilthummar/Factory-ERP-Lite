import 'package:file_picker/file_picker.dart';

import '../../../../utils/exports.dart';

/// Backup and restore settings screen.
@RoutePage()
class BackupRestorePage extends StatelessWidget {
  /// Creates [BackupRestorePage].
  const BackupRestorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BackupRestoreBloc>(
      create: (BuildContext context) => BackupRestoreBloc(
        getBackupOverviewUseCase: getIt<GetBackupOverviewUseCase>(),
        createJsonBackupUseCase: getIt<CreateJsonBackupUseCase>(),
        restoreJsonBackupUseCase: getIt<RestoreJsonBackupUseCase>(),
        backupToGoogleSheetsUseCase: getIt<BackupToGoogleSheetsUseCase>(),
      ),
      child: const _BackupRestoreView(),
    );
  }
}

class _BackupRestoreView extends StatelessWidget {
  const _BackupRestoreView();

  Future<void> _pickAndRestore(BuildContext context) async {
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

    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: CustomTextLabelWidget(
                label: context.appString.backupRestoreConfirmTitleKey,
              ),
              content: CustomTextLabelWidget(
                label: context.appString.backupRestoreConfirmMessageKey,
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

    context.read<BackupRestoreBloc>().add(
          BackupRestoreJsonImportRequested(result.files.single.path!),
        );
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
      body: BlocConsumer<BackupRestoreBloc, BackupRestoreState>(
        listener: (BuildContext context, BackupRestoreState state) {
          if (state.status == BackupRestoreStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (BuildContext context, BackupRestoreState state) {
          final bool isBusy = state.status == BackupRestoreStatus.loading ||
              state.status == BackupRestoreStatus.exportingJson ||
              state.status == BackupRestoreStatus.restoringJson ||
              state.status == BackupRestoreStatus.exportingSheets;

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
                CustomButtonWidget(
                  text: strings.backupRestoreJsonExportKey,
                  backgroundColor: colorScheme.primary,
                  onClick: isBusy
                      ? null
                      : () {
                          context.read<BackupRestoreBloc>().add(
                                const BackupRestoreJsonExportRequested(),
                              );
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
                  onClick: isBusy
                      ? null
                      : () => _pickAndRestore(context),
                  textStyle:
                      AppStyles.instance.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: Dimens.space12),
                CustomButtonWidget(
                  text: strings.backupRestoreGoogleSheetsKey,
                  backgroundColor: colorScheme.tertiaryContainer,
                  onClick: isBusy
                      ? null
                      : () {
                          context.read<BackupRestoreBloc>().add(
                                const BackupRestoreGoogleSheetsRequested(),
                              );
                        },
                  textStyle:
                      AppStyles.instance.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
                if (state.lastSheetsUrl != null) ...<Widget>[
                  const SizedBox(height: Dimens.space12),
                  TextButton(
                    onPressed: () {
                      unawaited(
                        launchUrl(
                          Uri.parse(state.lastSheetsUrl!),
                          mode: LaunchMode.externalApplication,
                        ),
                      );
                    },
                    child: CustomTextLabelWidget(
                      label: strings.backupRestoreOpenSheetsKey,
                    ),
                  ),
                ],
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
