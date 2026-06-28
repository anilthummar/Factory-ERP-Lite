import '../../../utils/exports.dart';

/// Web admin sync diagnostics (Firebase health, queue, retry).
class SyncDiagnosticsAdminPage extends StatelessWidget {
  /// Creates [SyncDiagnosticsAdminPage].
  const SyncDiagnosticsAdminPage({this.refreshTick = 0, super.key});

  /// Parent shell refresh counter.
  final int refreshTick;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SyncDiagnosticsBloc>(
      key: ValueKey<int>(refreshTick),
      create: (BuildContext context) => SyncDiagnosticsBloc(
        getSyncDiagnosticsUseCase: getIt<GetSyncDiagnosticsUseCase>(),
        retrySyncUseCase: getIt<RetrySyncUseCase>(),
      ),
      child: const _SyncDiagnosticsAdminView(),
    );
  }
}

class _SyncDiagnosticsAdminView extends StatelessWidget {
  const _SyncDiagnosticsAdminView();

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      strings.syncDiagnosticsTitleKey,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Firebase connectivity, sync queue, and manual retry',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: strings.syncDiagnosticsRefreshKey,
                onPressed: () => unawaited(_onRefresh(context)),
                icon: const Icon(Icons.refresh_outlined),
              ),
            ],
          ),
        ),
        const Expanded(child: SyncDiagnosticsPanel()),
      ],
    );
  }
}
