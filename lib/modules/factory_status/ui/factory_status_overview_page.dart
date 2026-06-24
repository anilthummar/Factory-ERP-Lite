import '../../../../core/domain/entities/factory_status_entity.dart';
import '../../../../utils/exports.dart';
import '../mapper/factory_status_ui_mapper.dart';

/// Factory status overview screen.
@RoutePage()
class FactoryStatusOverviewPage extends StatelessWidget {
  /// Creates [FactoryStatusOverviewPage].
  const FactoryStatusOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FactoryStatusBloc>(
      create: (BuildContext context) => FactoryStatusBloc(
        getHistoryUseCase: getIt<GetFactoryStatusHistoryUseCase>(),
        changeStatusUseCase: getIt<ChangeFactoryStatusUseCase>(),
      ),
      child: const _FactoryStatusOverviewView(),
    );
  }
}

class _FactoryStatusOverviewView extends StatelessWidget {
  const _FactoryStatusOverviewView();

  void _openChangeStatus(BuildContext context, FactoryStatusBloc bloc) {
    final FactoryStatusType? initialStatus =
        bloc.state.currentStatus?.status.toUi();
    unawaited(
      context.router.pushWidget(
        BlocProvider<FactoryStatusBloc>.value(
          value: bloc,
          child: FactoryStatusChangePage(
            initialStatus: initialStatus,
            initialNotes: bloc.state.currentStatus?.notes,
            onSave: (FactoryStatusType status, String? notes) {
              bloc.add(
                FactoryStatusChangeRequested(
                  status: status.toDomain(),
                  notes: notes,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _openHistory(BuildContext context) {
    unawaited(context.router.push(const FactoryStatusHistoryRoute()));
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return BlocConsumer<FactoryStatusBloc, FactoryStatusState>(
      listener: (BuildContext context, FactoryStatusState state) {
        if (state.status == FactoryStatusBlocStatus.saved) {
          unawaited(context.router.maybePop());
        }
      },
      builder: (BuildContext context, FactoryStatusState state) {
        final FactoryStatusBloc bloc = context.read<FactoryStatusBloc>();
        final FactoryStatusType currentUiStatus =
            state.currentStatus?.status.toUi() ??
                FactoryStatusType.operational;
        final List<FactoryStatusHistoryData> recentHistory =
            state.recentHistory
                .map(
                  (FactoryStatusEntity status) => FactoryStatusHistoryData(
                    id: status.id,
                    status: status.status.toUi(),
                    changedAt: status.updatedAt,
                    notes: status.notes,
                  ),
                )
                .toList(growable: false);
        final String? lastUpdated = state.currentStatus == null
            ? null
            : dateToString(
                state.currentStatus!.updatedAt,
                dateFormat: DateConstants.dateTimeFormat,
              );

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: CustomTextLabelWidget(
              label: strings.factoryStatusKey,
              textAlign: TextAlign.start,
            ),
          ),
          body: CustomResponsiveContent(
            child: state.status == FactoryStatusBlocStatus.loading &&
                    state.currentStatus == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(Dimens.padding16),
                    children: <Widget>[
                      FactoryStatusCurrentCard(
                        status: currentUiStatus,
                        lastUpdated: lastUpdated,
                      ),
                      const SizedBox(height: Dimens.space24),
                      CustomTextLabelWidget(
                        label: strings.factoryStatusNotesKey,
                        textAlign: TextAlign.start,
                        style:
                            AppStyles.instance.textTheme.titleSmall?.copyWith(
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
                              label: state.currentStatus?.notes?.isNotEmpty ??
                                      false
                                  ? state.currentStatus!.notes!
                                  : strings.factoryStatusNotesEmptyKey,
                              textAlign: TextAlign.start,
                              style: AppStyles.instance.textTheme.bodyMedium
                                  ?.copyWith(
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
                        onClick: () => _openChangeStatus(context, bloc),
                        textStyle:
                            AppStyles.instance.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: Dimens.space12),
                      CustomButtonWidget(
                        text: strings.viewStatusHistoryKey,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        onClick: () => _openHistory(context),
                        textStyle:
                            AppStyles.instance.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (recentHistory.isNotEmpty) ...<Widget>[
                        const SizedBox(height: Dimens.space24),
                        CustomTextLabelWidget(
                          label: strings.statusHistoryKey,
                          textAlign: TextAlign.start,
                          style: AppStyles.instance.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: Dimens.space12),
                        FactoryStatusHistoryTimeline(history: recentHistory),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}
