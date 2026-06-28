import '../../../../utils/exports.dart';

/// Shared layout for report detail screens (UI only).
class ReportScreenShell extends StatefulWidget {
  /// Creates [ReportScreenShell].
  const ReportScreenShell({
    required this.pageTitle,
    required this.searchHint,
    required this.filterConfig,
    required this.summaryCards,
    this.isEmpty = true,
    this.onSearchChanged,
    this.onFilterApply,
    this.onFilterClear,
    this.onExportPdf,
    this.onExportExcel,
    super.key,
  });

  /// Screen app bar title.
  final String pageTitle;

  /// Search field hint.
  final String searchHint;

  /// Filter bottom sheet configuration.
  final ReportFilterUiConfig filterConfig;

  /// Summary metric cards.
  final List<ReportSummaryCard> summaryCards;

  /// Whether the report data area is empty.
  final bool isEmpty;

  /// Search text change callback placeholder.
  final ValueChanged<String>? onSearchChanged;

  /// Filter apply callback placeholder.
  final VoidCallback? onFilterApply;

  /// Filter clear callback placeholder.
  final VoidCallback? onFilterClear;

  /// Export PDF callback placeholder.
  final VoidCallback? onExportPdf;

  /// Export Excel callback placeholder.
  final VoidCallback? onExportExcel;

  @override
  State<ReportScreenShell> createState() => _ReportScreenShellState();
}

class _ReportScreenShellState extends State<ReportScreenShell> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    unawaited(
      ReportFilterBottomSheet.show(
        context: context,
        config: widget.filterConfig,
        onApply: widget.onFilterApply,
        onClear: widget.onFilterClear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    final int summaryColumns = context.isMobileView ? 2 : 4;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: widget.pageTitle,
          textAlign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _openFilterSheet,
            icon: const Icon(Icons.filter_list_outlined),
            tooltip: widget.filterConfig.title,
          ),
        ],
      ),
      body: CustomResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.all(Dimens.padding16),
          children: <Widget>[
            CustomSearchFieldWidget(
              controller: _searchController,
              hint: widget.searchHint,
              onChanged: widget.onSearchChanged,
            ),
            const SizedBox(height: Dimens.space16),
            GridView.count(
              crossAxisCount: summaryColumns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: Dimens.space12,
              mainAxisSpacing: Dimens.space12,
              childAspectRatio: 1.35,
              children: widget.summaryCards,
            ),
            const SizedBox(height: Dimens.space16),
            const ReportChartPlaceholder(),
            const SizedBox(height: Dimens.space16),
            ReportExportActions(
              onExportPdf: widget.onExportPdf,
              onExportExcel: widget.onExportExcel,
            ),
            const SizedBox(height: Dimens.space24),
            SizedBox(
              height: Dimens.size200,
              child: widget.isEmpty
                  ? const ReportEmptyView()
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
