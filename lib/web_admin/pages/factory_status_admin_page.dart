import '../../../core/domain/entities/factory_status_entity.dart';
import '../../../utils/exports.dart';
import '../widgets/admin_centered_status_panel.dart';

/// Web admin factory status overview with change form and history.
class FactoryStatusAdminPage extends StatefulWidget {
  /// Creates [FactoryStatusAdminPage].
  const FactoryStatusAdminPage({this.refreshTick = 0, super.key});

  /// Parent shell refresh counter.
  final int refreshTick;

  @override
  State<FactoryStatusAdminPage> createState() => _FactoryStatusAdminPageState();
}

class _FactoryStatusAdminPageState extends State<FactoryStatusAdminPage> {
  late final FactoryStatusBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = FactoryStatusBloc(
      getCurrentStatusUseCase: getIt<GetCurrentFactoryStatusUseCase>(),
      getHistoryUseCase: getIt<GetFactoryStatusHistoryUseCase>(),
      changeStatusUseCase: getIt<ChangeFactoryStatusUseCase>(),
    );
  }

  @override
  void didUpdateWidget(covariant FactoryStatusAdminPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshTick != widget.refreshTick) {
      _bloc.add(const FactoryStatusRefreshRequested());
    }
  }

  @override
  void dispose() {
    unawaited(_bloc.close());
    super.dispose();
  }

  void _openChangeStatus(FactoryStatusBloc bloc) {
    final FactoryStatusType? initialStatus =
        bloc.state.currentStatus?.status.toUi();
    unawaited(
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => BlocProvider<FactoryStatusBloc>.value(
            value: bloc,
            child: BlocListener<FactoryStatusBloc, FactoryStatusState>(
              listener: (BuildContext context, FactoryStatusState state) {
                if (state.status == FactoryStatusBlocStatus.saved &&
                    context.mounted) {
                  Navigator.of(context).pop();
                }
              },
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FactoryStatusBloc>.value(
      value: _bloc,
      child: BlocBuilder<FactoryStatusBloc, FactoryStatusState>(
        builder: (BuildContext context, FactoryStatusState state) {
          final AppString strings = context.appString;
          final ColorScheme colorScheme = Theme.of(context).colorScheme;
          final FactoryStatusBloc bloc = context.read<FactoryStatusBloc>();

          if (state.status == FactoryStatusBlocStatus.loading &&
              state.currentStatus == null &&
              state.history.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FactoryStatusBlocStatus.failure &&
              state.currentStatus == null &&
              state.history.isEmpty) {
            return AdminCenteredStatusPanel(
              icon: Icons.error_outline,
              message: state.errorMessage ?? strings.somethingWentWrongKey,
              actionLabel: strings.syncDiagnosticsRefreshKey,
              onAction: () {
                bloc.add(const FactoryStatusLoadRequested());
              },
            );
          }

          final FactoryStatusType? currentUiStatus =
              state.currentStatus?.status.toUi();
          final List<FactoryStatusHistoryData> history =
              state.history
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

          return CustomResponsiveContent(
            child: ListView(
              padding: const EdgeInsets.all(Dimens.padding16),
              children: <Widget>[
                Text(
                  strings.factoryStatusKey,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: Dimens.space8),
                Text(
                  'View and update the current factory operating status',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: Dimens.space24),
                FactoryStatusCurrentCard(
                  status: currentUiStatus,
                  lastUpdated: lastUpdated,
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
                        label: state.currentStatus?.notes?.isNotEmpty ?? false
                            ? state.currentStatus!.notes!
                            : strings.factoryStatusNotesEmptyKey,
                        textAlign: TextAlign.start,
                        style: AppStyles.instance.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Dimens.space24),
                FilledButton.icon(
                  onPressed: state.status == FactoryStatusBlocStatus.loading
                      ? null
                      : () => _openChangeStatus(bloc),
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(strings.changeFactoryStatusKey),
                ),
                if (history.isNotEmpty) ...<Widget>[
                  const SizedBox(height: Dimens.space32),
                  CustomTextLabelWidget(
                    label: strings.statusHistoryKey,
                    textAlign: TextAlign.start,
                    style: AppStyles.instance.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: Dimens.space12),
                  FactoryStatusHistoryTimeline(history: history),
                ],
                if (state.status == FactoryStatusBlocStatus.loading)
                  const Padding(
                    padding: EdgeInsets.only(top: Dimens.space16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
