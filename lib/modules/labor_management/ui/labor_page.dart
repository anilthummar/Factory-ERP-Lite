import '../../../../utils/exports.dart';
import '../../../core/bloc/crud/crud_state.dart';
import '../../../core/domain/entities/labor_entity.dart';
import '../bloc/labor_bloc.dart';
import '../bloc/labor_event.dart';
import 'labor_form_page.dart';
import 'widget/labor_card.dart';

/// Labor management list screen.
@RoutePage()
class LaborPage extends StatelessWidget {
  const LaborPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LaborBloc>(
      create: (BuildContext context) => LaborBloc(
        getLaborUseCase: getIt<GetLaborUseCase>(),
        addLaborUseCase: getIt<AddLaborUseCase>(),
        updateLaborUseCase: getIt<UpdateLaborUseCase>(),
        deleteLaborUseCase: getIt<DeleteLaborUseCase>(),
        searchLaborUseCase: getIt<SearchLaborUseCase>(),
      ),
      child: const _LaborPageView(),
    );
  }
}

class _LaborPageView extends StatefulWidget {
  const _LaborPageView();

  @override
  State<_LaborPageView> createState() => _LaborPageViewState();
}

class _LaborPageViewState extends State<_LaborPageView> {
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
    final LaborBloc bloc = context.read<LaborBloc>();
    final Future<CrudState<LaborEntity>> nextState = bloc.stream
        .skip(1)
        .firstWhere((CrudState<LaborEntity> state) => !state.isLoading);
    bloc.add(const LaborRefreshRequested());
    await nextState;
  }

  void _openForm({LaborEntity? labor}) {
    final bool isEdit = labor != null;
    unawaited(
      context.router.pushWidget(
        LaborFormPage(
          isEdit: isEdit,
          initialName: labor?.name,
          initialMobile: labor?.mobile,
          initialSkill: labor?.skill,
          initialDailyWage: labor?.dailyWage.toStringAsFixed(2),
          initialNotes: labor?.notes,
          onSubmit: ({
            required String name,
            required String mobile,
            required String skill,
            required double dailyWage,
            String? notes,
          }) {
            final LaborBloc bloc = context.read<LaborBloc>();
            if (isEdit) {
              bloc.add(
                LaborUpdateRequested(
                  labor: labor,
                  name: name,
                  mobile: mobile,
                  skill: skill,
                  dailyWage: dailyWage,
                  notes: notes,
                ),
              );
            } else {
              bloc.add(
                LaborCreateRequested(
                  name: name,
                  mobile: mobile,
                  skill: skill,
                  dailyWage: dailyWage,
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

  List<LaborCardData> _mapLabor(List<LaborEntity> records) {
    return records
        .map(
          (LaborEntity labor) => LaborCardData(
            id: labor.id,
            name: labor.name,
            phone: labor.mobile,
            skill: labor.skill,
            dailyWage: labor.dailyWage.toStringAsFixed(2),
            onTap: () => _openForm(labor: labor),
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return BlocListener<LaborBloc, CrudState<LaborEntity>>(
      listenWhen: (
        CrudState<LaborEntity> previous,
        CrudState<LaborEntity> current,
      ) =>
          current.isError && previous.errorMessage != current.errorMessage,
      listener: (BuildContext context, CrudState<LaborEntity> state) {
        final String? message = state.errorMessage;
        if (message != null) {
          context.showAppSnackBar(message);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: CustomTextLabelWidget(
            label: strings.laborManagementKey,
            textAlign: TextAlign.start,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openForm(),
          icon: const Icon(Icons.person_add_alt_1_outlined),
          label: CustomTextLabelWidget(
            label: strings.addLaborKey,
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
                hint: strings.searchLaborKey,
                onChanged: (String value) {
                  context.read<LaborBloc>().add(LaborSearchRequested(value));
                },
              ),
              Expanded(
                child: BlocBuilder<LaborBloc, CrudState<LaborEntity>>(
                  builder: (
                    BuildContext context,
                    CrudState<LaborEntity> state,
                  ) {
                    if (state.isLoading && state.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return LaborListView(
                      laborRecords: _mapLabor(state.items),
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
