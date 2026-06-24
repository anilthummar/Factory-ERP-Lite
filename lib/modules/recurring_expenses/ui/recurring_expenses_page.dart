import '../../../../utils/exports.dart';
import '../../../core/bloc/crud/crud_state.dart';
import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../bloc/recurring_expense_bloc.dart';
import '../bloc/recurring_expense_event.dart';
import 'recurring_expense_form_page.dart';
import 'widget/recurring_expense_card.dart';
import 'widget/recurring_expense_frequency.dart';

/// Recurring expense list screen.
@RoutePage()
class RecurringExpensesPage extends StatelessWidget {
  const RecurringExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecurringExpenseBloc>(
      create: (BuildContext context) => RecurringExpenseBloc(
        getRecurringExpensesUseCase: getIt<GetRecurringExpensesUseCase>(),
        addRecurringExpenseUseCase: getIt<AddRecurringExpenseUseCase>(),
        updateRecurringExpenseUseCase: getIt<UpdateRecurringExpenseUseCase>(),
        deleteRecurringExpenseUseCase: getIt<DeleteRecurringExpenseUseCase>(),
        searchRecurringExpensesUseCase: getIt<SearchRecurringExpensesUseCase>(),
      ),
      child: const _RecurringExpensesPageView(),
    );
  }
}

class _RecurringExpensesPageView extends StatefulWidget {
  const _RecurringExpensesPageView();

  @override
  State<_RecurringExpensesPageView> createState() =>
      _RecurringExpensesPageViewState();
}

class _RecurringExpensesPageViewState extends State<_RecurringExpensesPageView> {
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

  Future<void> _onRefresh() async {
    final RecurringExpenseBloc bloc = context.read<RecurringExpenseBloc>();
    final Future<CrudState<RecurringExpenseEntity>> nextState = bloc.stream
        .skip(1)
        .firstWhere(
          (CrudState<RecurringExpenseEntity> state) => !state.isLoading,
        );
    bloc.add(const RecurringExpenseRefreshRequested());
    await nextState;
  }

  void _openForm({RecurringExpenseEntity? expense}) {
    final bool isEdit = expense != null;
    unawaited(
      context.router.pushWidget(
        RecurringExpenseFormPage(
          isEdit: isEdit,
          initialTitle: expense?.title,
          initialAmount: expense?.amount.toStringAsFixed(2),
          initialFrequency: expense?.frequency,
          initialStartDate:
              expense == null ? null : dateToString(expense.startDate),
          initialEndDate: expense?.endDate == null
              ? null
              : dateToString(expense!.endDate!),
          initialNotes: expense?.notes,
          onSubmit: ({
            required String title,
            required double amount,
            required RecurringExpenseFrequency frequency,
            required DateTime startDate,
            DateTime? endDate,
            String? notes,
          }) {
            final RecurringExpenseBloc bloc =
                context.read<RecurringExpenseBloc>();
            if (isEdit) {
              bloc.add(
                RecurringExpenseUpdateRequested(
                  expense: expense,
                  title: title,
                  amount: amount,
                  frequency: frequency,
                  startDate: startDate,
                  endDate: endDate,
                  notes: notes,
                ),
              );
            } else {
              bloc.add(
                RecurringExpenseCreateRequested(
                  title: title,
                  amount: amount,
                  frequency: frequency,
                  startDate: startDate,
                  endDate: endDate,
                  notes: notes,
                ),
              );
            }
            unawaited(context.router.maybePop());
          },
        ),
      ),
    );
  }

  List<RecurringExpenseCardData> _mapExpenses(
    List<RecurringExpenseEntity> expenses,
    AppString strings,
  ) {
    return expenses
        .map(
          (RecurringExpenseEntity expense) => RecurringExpenseCardData(
            id: expense.id,
            title: expense.title,
            amount: expense.amount.toStringAsFixed(2),
            frequency: expense.frequency.label(strings),
            startDate: dateToString(expense.startDate),
            endDate: expense.endDate == null
                ? null
                : dateToString(expense.endDate!),
            onTap: () => _openForm(expense: expense),
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return BlocListener<RecurringExpenseBloc,
        CrudState<RecurringExpenseEntity>>(
      listenWhen: (
        CrudState<RecurringExpenseEntity> previous,
        CrudState<RecurringExpenseEntity> current,
      ) =>
          current.isError && previous.errorMessage != current.errorMessage,
      listener: (BuildContext context, CrudState<RecurringExpenseEntity> state) {
        final String? message = state.errorMessage;
        if (message != null) {
          context.showAppSnackBar(message);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: CustomTextLabelWidget(
            label: strings.recurringExpensesKey,
            textAlign: TextAlign.start,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openForm(),
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
                onChanged: (String value) {
                  context
                      .read<RecurringExpenseBloc>()
                      .add(RecurringExpenseSearchRequested(value));
                },
              ),
              Expanded(
                child: BlocBuilder<RecurringExpenseBloc,
                    CrudState<RecurringExpenseEntity>>(
                  builder: (
                    BuildContext context,
                    CrudState<RecurringExpenseEntity> state,
                  ) {
                    if (state.isLoading && state.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return RecurringExpenseListView(
                      expenses: _mapExpenses(state.items, strings),
                      onRefresh: _onRefresh,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
