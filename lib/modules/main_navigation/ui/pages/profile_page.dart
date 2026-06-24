import '../../../../utils/exports.dart';

/// Profile tab placeholder.
class ProfileTabPage extends StatelessWidget {
  /// Creates [ProfileTabPage].
  const ProfileTabPage({super.key});

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: Dimens.radius34,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  Icons.person_outline,
                  size: Dimens.size40,
                  color: colorScheme.onPrimaryContainer,
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
        ),
      ),
    );
  }
}
