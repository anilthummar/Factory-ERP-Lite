import '../../../../utils/exports.dart';
import '../bloc/bloc.dart';
import '../domain/entities/explorer_filters.dart';
import '../domain/entities/explorer_record_item.dart';
import 'explorer_record_navigation.dart';
import 'widget/explorer_bottom_summary.dart';
import 'widget/explorer_empty_state.dart';
import 'widget/explorer_filter_sheet.dart';
import 'widget/explorer_record_tile.dart';
import 'widget/explorer_summary_cards.dart';

/// Unified search, filter, and export across all ERP modules.
@RoutePage()
class RecordsExplorerPage extends StatelessWidget {
  /// Creates [RecordsExplorerPage].
  const RecordsExplorerPage({this.initialQuery, super.key});

  /// Optional search text applied on first load.
  final String? initialQuery;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecordsExplorerBloc>(
      create: (BuildContext context) => RecordsExplorerBloc(
        searchRecordsUseCase: getIt<SearchRecordsUseCase>(),
        filterRecordsUseCase: getIt<FilterRecordsUseCase>(),
        exportFilteredRecordsUseCase: getIt<ExportFilteredRecordsUseCase>(),
        deleteExplorerRecordUseCase: getIt<DeleteExplorerRecordUseCase>(),
        initialQuery: initialQuery ?? '',
      ),
      child: const _RecordsExplorerView(),
    );
  }
}

class _RecordsExplorerView extends StatefulWidget {
  const _RecordsExplorerView();

  @override
  State<_RecordsExplorerView> createState() => _RecordsExplorerViewState();
}

class _RecordsExplorerViewState extends State<_RecordsExplorerView> {
  late final TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final RecordsExplorerBloc bloc = context.read<RecordsExplorerBloc>();
    _searchController =
        TextEditingController(text: bloc.state.filters.searchQuery);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final double max = _scrollController.position.maxScrollExtent;
    if (_scrollController.position.pixels >= max - 200) {
      final RecordsExplorerBloc bloc = context.read<RecordsExplorerBloc>();
      if (bloc.state.hasMore) {
        bloc.add(const RecordsExplorerLoadMoreRequested());
      }
    }
  }

  Future<void> _confirmDelete(ExplorerRecordItem record) async {
    final AppString strings = context.appString;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(record.name),
          content: Text(strings.recordsExplorerDeleteConfirmKey),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(strings.cancelKey),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                strings.recordsExplorerDeleteKey,
                style: TextStyle(color: context.theme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed == true && mounted) {
      context
          .read<RecordsExplorerBloc>()
          .add(RecordsExplorerDeleteRequested(record));
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return BlocConsumer<RecordsExplorerBloc, RecordsExplorerState>(
      listenWhen: (
        RecordsExplorerState previous,
        RecordsExplorerState current,
      ) =>
          current.status == RecordsExplorerStatus.failure &&
          current.errorMessage != null,
      listener: (BuildContext context, RecordsExplorerState state) {
        context.showAppSnackBar(state.errorMessage!);
      },
      builder: (BuildContext context, RecordsExplorerState state) {
        final bool isLoading =
            state.status == RecordsExplorerStatus.loading &&
                state.visibleRecords.isEmpty;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: CustomTextLabelWidget(
              label: strings.recordsExplorerTitleKey,
              textAlign: TextAlign.start,
            ),
            actions: <Widget>[
              IconButton(
                tooltip: strings.recordsExplorerFiltersKey,
                onPressed: () {
                  unawaited(
                    ExplorerFilterSheet.show(
                      context,
                      initialFilters: state.filters,
                      onApply: (ExplorerFilters filters) {
                        context
                            .read<RecordsExplorerBloc>()
                            .add(RecordsExplorerFiltersChanged(filters));
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.tune_outlined),
              ),
              IconButton(
                tooltip: strings.recordsExplorerExportPdfKey,
                onPressed: state.isExporting
                    ? null
                    : () {
                        context.read<RecordsExplorerBloc>().add(
                              const RecordsExplorerExportPdfRequested(),
                            );
                      },
                icon: const Icon(Icons.picture_as_pdf_outlined),
              ),
              IconButton(
                tooltip: strings.recordsExplorerExportExcelKey,
                onPressed: state.isExporting
                    ? null
                    : () {
                        context.read<RecordsExplorerBloc>().add(
                              const RecordsExplorerExportExcelRequested(),
                            );
                      },
                icon: const Icon(Icons.table_chart_outlined),
              ),
            ],
          ),
          bottomNavigationBar: ExplorerBottomSummary(summary: state.summary),
          body: RefreshIndicator(
            onRefresh: () async {
              context
                  .read<RecordsExplorerBloc>()
                  .add(const RecordsExplorerRefreshRequested());
              await context.read<RecordsExplorerBloc>().stream.firstWhere(
                    (RecordsExplorerState next) =>
                        next.status == RecordsExplorerStatus.success ||
                        next.status == RecordsExplorerStatus.failure,
                  );
            },
            child: CustomResponsiveContent(
              child: ListView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(Dimens.padding16),
                children: <Widget>[
                  CustomTextLabelWidget(
                    label: strings.recordsExplorerSubtitleKey,
                    textAlign: TextAlign.start,
                    style: AppStyles.instance.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Dimens.space16),
                  ExplorerSummaryCards(
                    summary: state.summary,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: Dimens.space16),
                  CustomSearchFieldWidget(
                    controller: _searchController,
                    hint: strings.recordsExplorerSearchHintKey,
                    onChanged: (String value) {
                      context.read<RecordsExplorerBloc>().add(
                            RecordsExplorerSearchChanged(value),
                          );
                    },
                  ),
                  const SizedBox(height: Dimens.space16),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (state.visibleRecords.isEmpty)
                    ExplorerEmptyState(
                      onClearFilters: () {
                        _searchController.clear();
                        context
                            .read<RecordsExplorerBloc>()
                            .add(const RecordsExplorerFiltersCleared());
                      },
                    )
                  else
                    ...state.visibleRecords.map((ExplorerRecordItem record) {
                      return ExplorerRecordTile(
                        record: record,
                        onView: () => unawaited(
                          ExplorerRecordNavigation.openModule(context, record),
                        ),
                        onEdit: () => unawaited(
                          ExplorerRecordNavigation.openModule(context, record),
                        ),
                        onDelete: () => unawaited(_confirmDelete(record)),
                        onShare: () => unawaited(
                          ExplorerRecordNavigation.shareRecord(context, record),
                        ),
                      );
                    }),
                  if (state.hasMore)
                    const Padding(
                      padding: EdgeInsets.all(Dimens.padding16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
