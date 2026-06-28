import 'package:flutter/foundation.dart';

import '../../../../utils/exports.dart';

/// Profile tab with hidden developer entry to sync diagnostics.
class ProfileTabPage extends StatefulWidget {
  /// Creates [ProfileTabPage].
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  static const int _developerTapThreshold = 7;

  int _avatarTapCount = 0;

  void _onAvatarTap() {
    if (!kDebugMode) {
      return;
    }

    _avatarTapCount++;
    if (_avatarTapCount >= _developerTapThreshold) {
      _avatarTapCount = 0;
      unawaited(context.router.push(const SyncDiagnosticsRoute()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: context.appString.navProfileKey,
          textAlign: TextAlign.start,
        ),
      ),
      body: CustomResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.all(Dimens.space24),
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: _onAvatarTap,
                  child: CircleAvatar(
                    radius: Dimens.radius34,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person_outline,
                      size: Dimens.size40,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: Dimens.space16),
                CustomTextLabelWidget(
                  label: context.appString.profilePageKey,
                  style: AppStyles.instance.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: Dimens.space8),
                CustomTextLabelWidget(
                  label: context.appString.profileSettingsHintKey,
                  style: AppStyles.instance.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.space24),
            Card(
              elevation: Dimens.elevation0,
              color: colorScheme.surfaceContainerLow,
              child: ListTile(
                leading: Icon(
                  Icons.backup_outlined,
                  color: colorScheme.primary,
                ),
                title: CustomTextLabelWidget(
                  label: context.appString.backupRestoreProfileEntryKey,
                  textAlign: TextAlign.start,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  unawaited(
                    context.router.push(const BackupRestoreRoute()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
