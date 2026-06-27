import '../../../../utils/exports.dart';
import '../../../core/bloc/crud/crud_state.dart';
import '../../../core/domain/entities/person_entity.dart';

/// Person management list screen.
@RoutePage()
class PersonPage extends StatelessWidget {
  /// Creates [PersonPage].
  const PersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonBloc>(
      create: (BuildContext context) => PersonBloc(
        getPersonsUseCase: getIt<GetPersonsUseCase>(),
        addPersonUseCase: getIt<AddPersonUseCase>(),
        updatePersonUseCase: getIt<UpdatePersonUseCase>(),
        deletePersonUseCase: getIt<DeletePersonUseCase>(),
        searchPersonsUseCase: getIt<SearchPersonsUseCase>(),
      ),
      child: const _PersonPageView(),
    );
  }
}

class _PersonPageView extends StatefulWidget {
  const _PersonPageView();

  @override
  State<_PersonPageView> createState() => _PersonPageViewState();
}

class _PersonPageViewState extends State<_PersonPageView> {
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
    await pullRemoteBeforeLocalRefresh(() async {
      final PersonBloc bloc = context.read<PersonBloc>();
      final Future<CrudState<PersonEntity>> nextState = bloc.stream
          .skip(1)
          .firstWhere((CrudState<PersonEntity> state) => !state.isLoading);
      bloc.add(const PersonRefreshRequested());
      await nextState;
    });
  }

  void _onAddPerson() {
    _openPersonForm();
  }

  void _openPersonForm({PersonEntity? person}) {
    final bool isEdit = person != null;
    unawaited(
      context.router.pushWidget(
        PersonFormPage(
          isEdit: isEdit,
          initialName: person?.name,
          initialMobile: person?.mobile,
          initialAddress: person?.address,
          initialNotes: person?.notes,
          onSubmit: ({
            required String name,
            required String mobile,
            String? address,
            String? notes,
          }) {
            final PersonBloc bloc = context.read<PersonBloc>();
            if (isEdit) {
              bloc.add(
                PersonUpdateRequested(
                  person: person,
                  name: name,
                  mobile: mobile,
                  address: address,
                  notes: notes,
                ),
              );
            } else {
              bloc.add(
                PersonCreateRequested(
                  name: name,
                  mobile: mobile,
                  address: address,
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

  Future<void> _confirmDelete(PersonEntity person) async {
    final AppString strings = context.appString;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: CustomTextLabelWidget(
            label: person.name,
            textAlign: TextAlign.start,
          ),
          content: CustomTextLabelWidget(
            label: strings.deletePersonConfirmKey,
            textAlign: TextAlign.start,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(strings.cancelKey),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                strings.deletePersonKey,
                style: TextStyle(color: context.theme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      context.read<PersonBloc>().add(PersonDeleteRequested(person.id));
    }
  }

  void _onSearchChanged(String value) {
    context.read<PersonBloc>().add(PersonSearchRequested(value));
  }

  List<PersonCardData> _mapPersons(List<PersonEntity> persons) {
    return persons
        .map(
          (PersonEntity person) => PersonCardData(
            entity: person,
            roleLabel: _resolveRoleLabel(person),
            onTap: () => _openPersonForm(person: person),
            onDelete: () => unawaited(_confirmDelete(person)),
          ),
        )
        .toList(growable: false);
  }

  String _resolveRoleLabel(PersonEntity person) {
    final String? address = person.address?.trim();
    if (address != null && address.isNotEmpty) {
      return address;
    }

    final String? notes = person.notes?.trim();
    if (notes != null && notes.isNotEmpty) {
      return notes;
    }

    return person.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return BlocListener<PersonBloc, CrudState<PersonEntity>>(
      listenWhen: (
        CrudState<PersonEntity> previous,
        CrudState<PersonEntity> current,
      ) =>
          current.isError && previous.errorMessage != current.errorMessage,
      listener: (BuildContext context, CrudState<PersonEntity> state) {
        final String? message = state.errorMessage;
        if (message != null) {
          context.showAppSnackBar(message);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: CustomTextLabelWidget(
            label: strings.personManagementKey,
            textAlign: TextAlign.start,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _onAddPerson,
          icon: const Icon(Icons.person_add_outlined),
          label: CustomTextLabelWidget(
            label: strings.addPersonKey,
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
                hint: strings.searchPersonsKey,
                onChanged: _onSearchChanged,
              ),
              Expanded(
                child: BlocBuilder<PersonBloc, CrudState<PersonEntity>>(
                  builder: (
                    BuildContext context,
                    CrudState<PersonEntity> state,
                  ) {
                    if (state.isLoading && state.items.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return PersonListView(
                      persons: _mapPersons(state.items),
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
