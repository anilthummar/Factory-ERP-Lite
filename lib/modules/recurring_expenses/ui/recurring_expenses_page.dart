import '../../../../utils/exports.dart';

/// Recurring expense list screen.
@RoutePage()
class RecurringExpensesPage extends StatefulWidget {
  /// Creates [RecurringExpensesPage].
  const RecurringExpensesPage({super.key});

  @override
  State<RecurringExpensesPage> createState() => _RecurringExpensesPageState();
}

class _RecurringExpensesPageState extends State<RecurringExpensesPage> {
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

  Future<void> _onRefresh() async {}

  void _onSearchChanged(String value) {}

  void _onFilterApply() {}

  void _onFilterClear() {}

  void _onAdd() {
    unawaited(
      context.router.pushWidget(
        RecurringExpenseFormPage(
          onSave: () => context.router.maybePop(),
        ),
      ),
    );
  }

  void _openFilterSheet() {
    final AppString strings = context.appString;

    unawaited(
      ExpenseFilterBottomSheet.show(
        context: context,
        config: ExpenseFilterUiConfig.of(strings),
        onApply: _onFilterApply,
        onClear: _onFilterClear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.recurringExpensesKey,
          textAlign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _openFilterSheet,
            icon: const Icon(Icons.filter_list_outlined),
            tooltip: strings.filterKey,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAdd,
        icon: const Icon(Icons.add_outlined),
        label: CustomTextLabelWidget(
          label: strings.addRecurringExpenseKey,
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
              hint: strings.searchRecurringExpensesKey,
              onChanged: _onSearchChanged,
            ),
            Expanded(
              child: RecurringExpenseListView(
                expenses: const <RecurringExpenseCardData>[],
                onRefresh: _onRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
