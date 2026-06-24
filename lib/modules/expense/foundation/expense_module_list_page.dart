import '../../../../utils/exports.dart';
import '../../../core/bloc/crud/crud_state.dart';
import '../../../core/domain/entities/expense_entity.dart';
import '../ui/expense_form_page.dart';
import '../ui/expense_list_page.dart';
import '../ui/widget/expense_card.dart';
import 'expense_module_bloc.dart';
import 'expense_module_event.dart';

/// Offline-first expense list wired to a module-specific [ExpenseModuleBloc].
class ExpenseModuleListPage extends StatelessWidget {
  /// Creates [ExpenseModuleListPage].
  const ExpenseModuleListPage({
    required this.pageTitle,
    super.key,
  });

  /// Module-specific screen title.
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseModuleBloc, CrudState<ExpenseEntity>>(
      listenWhen: (
        CrudState<ExpenseEntity> previous,
        CrudState<ExpenseEntity> current,
      ) =>
          current.isError && previous.errorMessage != current.errorMessage,
      listener: (BuildContext context, CrudState<ExpenseEntity> state) {
        final String? message = state.errorMessage;
        if (message != null) {
          context.showAppSnackBar(message);
        }
      },
      child: _ExpenseModuleListView(pageTitle: pageTitle),
    );
  }
}

class _ExpenseModuleListView extends StatefulWidget {
  const _ExpenseModuleListView({required this.pageTitle});

  final String pageTitle;

  @override
  State<_ExpenseModuleListView> createState() => _ExpenseModuleListViewState();
}

class _ExpenseModuleListViewState extends State<_ExpenseModuleListView> {
  Future<void> _onRefresh() async {
    final ExpenseModuleBloc bloc = context.read<ExpenseModuleBloc>();
    final Future<CrudState<ExpenseEntity>> nextState = bloc.stream
        .skip(1)
        .firstWhere((CrudState<ExpenseEntity> state) => !state.isLoading);
    bloc.add(const ExpenseModuleRefreshRequested());
    await nextState;
  }

  void _onAdd() {
    final AppString strings = context.appString;
    unawaited(
      context.router.pushWidget(
        ExpenseFormPage(
          config: ExpenseFormUiConfig.of(
            strings,
            pageTitleAdd: widget.pageTitle,
          ),
          onSubmit: ({
            required String title,
            required double amount,
            required DateTime date,
            String? notes,
            String? attachmentPath,
          }) {
            context.read<ExpenseModuleBloc>().add(
                  ExpenseModuleCreateRequested(
                    title: title,
                    amount: amount,
                    date: date,
                    notes: notes,
                    attachmentPath: attachmentPath,
                  ),
                );
            unawaited(context.router.maybePop());
          },
        ),
      ),
    );
  }

  List<ExpenseCardData> _mapExpenses(List<ExpenseEntity> expenses) {
    return expenses
        .map(
          (ExpenseEntity expense) => ExpenseCardData(
            id: expense.id,
            title: expense.title,
            amount: expense.amount.toStringAsFixed(2),
            date: dateToString(expense.date),
            onTap: () => _openEdit(expense),
          ),
        )
        .toList(growable: false);
  }

  void _openEdit(ExpenseEntity expense) {
    final AppString strings = context.appString;
    unawaited(
      context.router.pushWidget(
        ExpenseFormPage(
          isEdit: true,
          initialTitle: expense.title,
          initialAmount: expense.amount.toStringAsFixed(2),
          initialDate: dateToString(expense.date),
          initialNotes: expense.notes,
          initialAttachmentPath: expense.attachmentPath,
          config: ExpenseFormUiConfig.of(
            strings,
            pageTitleAdd: widget.pageTitle,
          ),
          onSubmit: ({
            required String title,
            required double amount,
            required DateTime date,
            String? notes,
            String? attachmentPath,
          }) {
            context.read<ExpenseModuleBloc>().add(
                  ExpenseModuleUpdateRequested(
                    expense: expense,
                    title: title,
                    amount: amount,
                    date: date,
                    notes: notes,
                    attachmentPath: attachmentPath,
                  ),
                );
            unawaited(context.router.maybePop());
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return BlocBuilder<ExpenseModuleBloc, CrudState<ExpenseEntity>>(
      builder: (BuildContext context, CrudState<ExpenseEntity> state) {
        if (state.isLoading && state.items.isEmpty) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: context.theme.colorScheme.primary,
              ),
            ),
          );
        }

        return ExpenseListPage(
          config: ExpenseListUiConfig.of(
            strings,
            pageTitle: widget.pageTitle,
          ),
          expenses: _mapExpenses(state.items),
          onRefresh: _onRefresh,
          onAdd: _onAdd,
          onSearchChanged: (String value) {
            context
                .read<ExpenseModuleBloc>()
                .add(ExpenseModuleSearchRequested(value));
          },
        );
      },
    );
  }
}
