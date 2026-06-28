import '../../../../utils/exports.dart';

/// Localized configuration for [ExpenseListPage].
class ExpenseListUiConfig {
  /// Creates [ExpenseListUiConfig].
  const ExpenseListUiConfig({
    required this.pageTitle,
    required this.searchHint,
    required this.addLabel,
    required this.emptyConfig,
    required this.filterConfig,
  });

  /// Builds shared expense list labels; [pageTitle] is module-specific.
  factory ExpenseListUiConfig.of(
    AppString strings, {
    required String pageTitle,
  }) {
    return ExpenseListUiConfig(
      pageTitle: pageTitle,
      searchHint: strings.searchExpensesKey,
      addLabel: strings.addExpenseKey,
      emptyConfig: ExpenseEmptyUiConfig.of(strings),
      filterConfig: ExpenseFilterUiConfig.of(strings),
    );
  }

  /// Module-specific screen title.
  final String pageTitle;

  /// Search field hint.
  final String searchHint;

  /// FAB label.
  final String addLabel;

  /// Empty state configuration.
  final ExpenseEmptyUiConfig emptyConfig;

  /// Filter sheet configuration.
  final ExpenseFilterUiConfig filterConfig;
}

/// Reusable expense list screen for all expense modules.
class ExpenseListPage extends StatefulWidget {
  /// Creates [ExpenseListPage].
  const ExpenseListPage({
    required this.config,
    this.expenses = const <ExpenseCardData>[],
    this.onRefresh,
    this.onAdd,
    this.onSearchChanged,
    this.onFilterApply,
    this.onFilterClear,
    super.key,
  });

  /// Localized UI configuration.
  final ExpenseListUiConfig config;

  /// Expense records to display.
  final List<ExpenseCardData> expenses;

  /// Pull-to-refresh placeholder callback.
  final Future<void> Function()? onRefresh;

  /// FAB tap callback placeholder.
  final VoidCallback? onAdd;

  /// Search text change callback placeholder.
  final ValueChanged<String>? onSearchChanged;

  /// Filter apply callback placeholder.
  final VoidCallback? onFilterApply;

  /// Filter clear callback placeholder.
  final VoidCallback? onFilterClear;

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
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

  Future<void> _handleRefresh() async {
    await widget.onRefresh?.call();
  }

  void _openFilterSheet() {
    unawaited(
      ExpenseFilterBottomSheet.show(
        context: context,
        config: widget.config.filterConfig,
        onApply: widget.onFilterApply,
        onClear: widget.onFilterClear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseListUiConfig config = widget.config;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: config.pageTitle,
          textAlign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _openFilterSheet,
            icon: const Icon(Icons.filter_list_outlined),
            tooltip: config.filterConfig.title,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAdd,
        icon: const Icon(Icons.add_outlined),
        label: CustomTextLabelWidget(
          label: config.addLabel,
          style: AppStyles.instance.textTheme.labelMedium?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      body: CustomResponsiveContent(
        child: Column(
          children: <Widget>[
            CustomSearchFieldWidget(
              controller: _searchController,
              hint: config.searchHint,
              onChanged: widget.onSearchChanged,
            ),
            Expanded(
              child: CustomRefreshableListView(
                isEmpty: widget.expenses.isEmpty,
                onRefresh: _handleRefresh,
                emptyView: ExpenseEmptyView(config: config.emptyConfig),
                itemCount: widget.expenses.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpenseCard(expense: widget.expenses[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
