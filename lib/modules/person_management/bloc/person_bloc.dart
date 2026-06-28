import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/crud/crud_state.dart';
import '../../../core/bloc/crud/crud_state_status.dart';
import '../../../core/domain/entities/person_entity.dart';
import '../../../core/enums/sync_status.dart';
import '../../../service/network/response_handler.dart';
import '../domain/usecases/add_person_use_case.dart';
import '../domain/usecases/delete_person_use_case.dart';
import '../domain/usecases/get_persons_use_case.dart';
import '../domain/usecases/search_persons_use_case.dart';
import '../domain/usecases/update_person_use_case.dart';
import 'person_event.dart';

/// BLoC for person list, search, and CRUD via use cases.
class PersonBloc extends Bloc<PersonEvent, CrudState<PersonEntity>> {
  /// Creates [PersonBloc].
  PersonBloc({
    required GetPersonsUseCase getPersonsUseCase,
    required AddPersonUseCase addPersonUseCase,
    required UpdatePersonUseCase updatePersonUseCase,
    required DeletePersonUseCase deletePersonUseCase,
    required SearchPersonsUseCase searchPersonsUseCase,
  })  : _getPersonsUseCase = getPersonsUseCase,
        _addPersonUseCase = addPersonUseCase,
        _updatePersonUseCase = updatePersonUseCase,
        _deletePersonUseCase = deletePersonUseCase,
        _searchPersonsUseCase = searchPersonsUseCase,
        super(CrudState<PersonEntity>()) {
    on<PersonLoadRequested>(_onLoad);
    on<PersonRefreshRequested>(_onRefresh);
    on<PersonSearchRequested>(_onSearch);
    on<PersonCreateRequested>(_onCreate);
    on<PersonUpdateRequested>(_onUpdate);
    on<PersonDeleteRequested>(_onDelete);

    add(const PersonLoadRequested());
  }

  final GetPersonsUseCase _getPersonsUseCase;
  final AddPersonUseCase _addPersonUseCase;
  final UpdatePersonUseCase _updatePersonUseCase;
  final DeletePersonUseCase _deletePersonUseCase;
  final SearchPersonsUseCase _searchPersonsUseCase;

  String _searchQuery = '';

  Future<void> _onLoad(
    PersonLoadRequested event,
    Emitter<CrudState<PersonEntity>> emit,
  ) async {
    _searchQuery = '';
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final ResponseHandler<List<PersonEntity>> result =
        await _getPersonsUseCase();
    _emitListResult(result, emit);
  }

  Future<void> _onRefresh(
    PersonRefreshRequested event,
    Emitter<CrudState<PersonEntity>> emit,
  ) async {
    if (state.items.isEmpty) {
      emit(
        state.copyWith(
          status: CrudStateStatus.loading,
          clearError: true,
        ),
      );
    }

    await _reloadCurrentView(emit);
  }

  Future<void> _onSearch(
    PersonSearchRequested event,
    Emitter<CrudState<PersonEntity>> emit,
  ) async {
    _searchQuery = event.query.trim();
    if (_searchQuery.isEmpty) {
      add(const PersonLoadRequested());
      return;
    }

    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final ResponseHandler<List<PersonEntity>> result =
        await _searchPersonsUseCase(_searchQuery);
    _emitListResult(result, emit);
  }

  Future<void> _onCreate(
    PersonCreateRequested event,
    Emitter<CrudState<PersonEntity>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final DateTime now = DateTime.now();
    final PersonEntity person = PersonEntity(
      id: 'person_${now.microsecondsSinceEpoch}',
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
      name: event.name,
      mobile: event.mobile,
      address: event.address,
      notes: event.notes,
    );

    final ResponseHandler<PersonEntity> result =
        await _addPersonUseCase(person);
    await _emitMutationResult(result, emit);
  }

  Future<void> _onUpdate(
    PersonUpdateRequested event,
    Emitter<CrudState<PersonEntity>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final PersonEntity updatedPerson = PersonEntity(
      id: event.person.id,
      createdAt: event.person.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
      name: event.name,
      mobile: event.mobile,
      address: event.address,
      notes: event.notes,
    );

    final ResponseHandler<PersonEntity> result =
        await _updatePersonUseCase(updatedPerson);
    await _emitMutationResult(result, emit);
  }

  Future<void> _onDelete(
    PersonDeleteRequested event,
    Emitter<CrudState<PersonEntity>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    final ResponseHandler<void> result =
        await _deletePersonUseCase(event.id);
    if (result is OnSuccessResponse<void>) {
      await _reloadCurrentView(emit);
      return;
    }

    _emitError(result, emit);
  }

  Future<void> _reloadCurrentView(
    Emitter<CrudState<PersonEntity>> emit,
  ) async {
    final ResponseHandler<List<PersonEntity>> result = _searchQuery.isEmpty
        ? await _getPersonsUseCase()
        : await _searchPersonsUseCase(_searchQuery);
    _emitListResult(result, emit);
  }

  void _emitListResult(
    ResponseHandler<List<PersonEntity>> result,
    Emitter<CrudState<PersonEntity>> emit,
  ) {
    if (result is OnSuccessResponse<List<PersonEntity>>) {
      emit(crudStateFromItems<PersonEntity>(result.response));
      return;
    }

    _emitError(result, emit);
  }

  Future<void> _emitMutationResult(
    ResponseHandler<PersonEntity> result,
    Emitter<CrudState<PersonEntity>> emit,
  ) async {
    if (result is OnSuccessResponse<PersonEntity>) {
      await _reloadCurrentView(emit);
      return;
    }

    _emitError(result, emit);
  }

  void _emitError<T>(
    ResponseHandler<T> result,
    Emitter<CrudState<PersonEntity>> emit,
  ) {
    final String message = result.getFailureInstance()?.error?.errorMessage ??
        'Something went wrong. Please try again.';
    emit(
      state.copyWith(
        status: CrudStateStatus.error,
        errorMessage: message,
      ),
    );
  }
}
