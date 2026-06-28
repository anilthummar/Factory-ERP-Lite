import '../../../../utils/exports.dart';

/// Hidden developer screen for inspecting offline sync health.
@RoutePage()
class SyncDiagnosticsPage extends StatelessWidget {
  /// Creates [SyncDiagnosticsPage].
  const SyncDiagnosticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SyncDiagnosticsBloc>(
      create: (BuildContext context) => SyncDiagnosticsBloc(
        getSyncDiagnosticsUseCase: getIt<GetSyncDiagnosticsUseCase>(),
        retrySyncUseCase: getIt<RetrySyncUseCase>(),
      ),
      child: const _SyncDiagnosticsView(),
    );
  }
}

class _SyncDiagnosticsView extends StatelessWidget {
  const _SyncDiagnosticsView();

  Future<void> _onRefresh(BuildContext context) async {
    final SyncDiagnosticsBloc bloc = context.read<SyncDiagnosticsBloc>();
    await pullRemoteBeforeLocalRefresh(() async {
      bloc.add(const SyncDiagnosticsLoadRequested());
      await bloc.stream.firstWhere(
        (SyncDiagnosticsState next) =>
            next.status == SyncDiagnosticsStatus.success ||
            next.status == SyncDiagnosticsStatus.failure,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.syncDiagnosticsTitleKey,
          textAlign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => unawaited(_onRefresh(context)),
            icon: const Icon(Icons.refresh_outlined),
            tooltip: strings.syncDiagnosticsRefreshKey,
          ),
        ],
      ),
      body: const CustomResponsiveContent(
        child: SyncDiagnosticsPanel(),
      ),
    );
  }
}
