import '../../../../utils/exports.dart';

/// Factory status overview screen (UI only).
@RoutePage()
class FactoryStatusOverviewPage extends BaseResponsiveView {
  /// Creates [FactoryStatusOverviewPage].
  const FactoryStatusOverviewPage({super.key});

  @override
  Widget buildMobileWidget(BuildContext context) => _buildBody(context);

  @override
  Widget buildTabletWidget(BuildContext context) => _buildBody(context);

  @override
  Widget buildDesktopWidget(BuildContext context) => _buildBody(context);

  void _openChangeStatus(BuildContext context) {
    unawaited(
      context.router.pushWidget(
        FactoryStatusChangePage(
          initialStatus: FactoryStatusType.operational,
          onSave: () => context.router.maybePop(),
        ),
      ),
    );
  }

  void _openHistory(BuildContext context) {
    unawaited(context.router.push(const FactoryStatusHistoryRoute()));
  }

  Widget _buildBody(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;
    const FactoryStatusType currentStatus = FactoryStatusType.operational;
    const List<FactoryStatusHistoryData> recentHistory =
        <FactoryStatusHistoryData>[];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.factoryStatusKey,
          textAlign: TextAlign.start,
        ),
      ),
      body: CustomResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.all(Dimens.padding16),
          children: <Widget>[
            const FactoryStatusCurrentCard(
              status: currentStatus,
            ),
            const SizedBox(height: Dimens.space24),
            CustomTextLabelWidget(
              label: strings.factoryStatusNotesKey,
              textAlign: TextAlign.start,
              style: AppStyles.instance.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Dimens.space12),
            Card(
              elevation: Dimens.elevation0,
              color: colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radius12),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.padding16),
                  child: CustomTextLabelWidget(
                    label: strings.factoryStatusNotesEmptyKey,
                    textAlign: TextAlign.start,
                    style: AppStyles.instance.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Dimens.space24),
            CustomButtonWidget(
              text: strings.changeFactoryStatusKey,
              backgroundColor: colorScheme.primary,
              onClick: () => _openChangeStatus(context),
              textStyle: AppStyles.instance.textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: Dimens.space12),
            CustomButtonWidget(
              text: strings.viewStatusHistoryKey,
              backgroundColor: colorScheme.surfaceContainerHighest,
              onClick: () => _openHistory(context),
              textStyle: AppStyles.instance.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            if (recentHistory.isNotEmpty) ...<Widget>[
              const SizedBox(height: Dimens.space24),
              CustomTextLabelWidget(
                label: strings.statusHistoryKey,
                textAlign: TextAlign.start,
                style: AppStyles.instance.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: Dimens.space12),
              const FactoryStatusHistoryTimeline(history: recentHistory),
            ],
          ],
        ),
      ),
    );
  }
}
