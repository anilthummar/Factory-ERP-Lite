import 'package:flutter_bloc/flutter_bloc.dart';

import 'crud_event.dart';
import 'crud_state.dart';
import 'crud_state_status.dart';

/// Generic CRUD BLoC foundation for ERP feature modules.
///
/// Subclasses implement [onLoadItems], [onCreateItem], [onUpdateItem], and
/// [onDeleteItem] to connect domain repositories.
abstract class CrudBloc<T> extends Bloc<CrudEvent<T>, CrudState<T>> {
  /// Creates [CrudBloc].
  CrudBloc({CrudState<T>? initialState}) : super(initialState ?? CrudState<T>()) {
    on<CrudLoadEvent<T>>(_onLoad);
    on<CrudRefreshEvent<T>>(_onRefresh);
    on<CrudCreateEvent<T>>(_onCreate);
    on<CrudUpdateEvent<T>>(_onUpdate);
    on<CrudDeleteEvent<T>>(_onDelete);
    on<CrudSelectEvent<T>>(_onSelect);
    on<CrudClearSelectionEvent<T>>(_onClearSelection);
    on<CrudResetEvent<T>>(_onReset);
  }

  /// Loads all records from the data source.
  Future<List<T>> onLoadItems();

  /// Persists a new record.
  Future<T> onCreateItem(T item);

  /// Updates an existing record.
  Future<T> onUpdateItem(T item);

  /// Deletes a record by [id].
  Future<void> onDeleteItem(String id);

  /// Maps thrown errors to a display message. Override for localization.
  String mapError(Object error) => error.toString();

  Future<void> _onLoad(
    CrudLoadEvent<T> event,
    Emitter<CrudState<T>> emit,
  ) async {
    await _loadItems(emit, showLoading: true);
  }

  Future<void> _onRefresh(
    CrudRefreshEvent<T> event,
    Emitter<CrudState<T>> emit,
  ) async {
    await _loadItems(emit, showLoading: state.items.isEmpty);
  }

  Future<void> _onCreate(
    CrudCreateEvent<T> event,
    Emitter<CrudState<T>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    try {
      final T created = await onCreateItem(event.item);
      final List<T> items = <T>[...state.items, created];
      emit(
        crudStateFromItems<T>(items).copyWith(
          selectedItem: created,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: CrudStateStatus.error,
          errorMessage: mapError(error),
        ),
      );
    }
  }

  Future<void> _onUpdate(
    CrudUpdateEvent<T> event,
    Emitter<CrudState<T>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    try {
      final T updated = await onUpdateItem(event.item);
      final List<T> items = _replaceItem(state.items, updated);
      emit(
        crudStateFromItems<T>(items).copyWith(
          selectedItem: updated,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: CrudStateStatus.error,
          errorMessage: mapError(error),
        ),
      );
    }
  }

  Future<void> _onDelete(
    CrudDeleteEvent<T> event,
    Emitter<CrudState<T>> emit,
  ) async {
    emit(
      state.copyWith(
        status: CrudStateStatus.loading,
        clearError: true,
      ),
    );

    try {
      await onDeleteItem(event.id);
      final List<T> items = _removeItemById(state.items, event.id);
      emit(
        crudStateFromItems<T>(items).copyWith(
          clearSelectedItem: _isSelectedId(event.id),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: CrudStateStatus.error,
          errorMessage: mapError(error),
        ),
      );
    }
  }

  void _onSelect(
    CrudSelectEvent<T> event,
    Emitter<CrudState<T>> emit,
  ) {
    emit(
      state.copyWith(
        selectedItem: event.item,
        clearError: true,
      ),
    );
  }

  void _onClearSelection(
    CrudClearSelectionEvent<T> event,
    Emitter<CrudState<T>> emit,
  ) {
    emit(state.copyWith(clearSelectedItem: true));
  }

  void _onReset(
    CrudResetEvent<T> event,
    Emitter<CrudState<T>> emit,
  ) {
    emit(CrudState<T>());
  }

  Future<void> _loadItems(
    Emitter<CrudState<T>> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) {
      emit(
        state.copyWith(
          status: CrudStateStatus.loading,
          clearError: true,
        ),
      );
    }

    try {
      final List<T> items = await onLoadItems();
      emit(crudStateFromItems<T>(items));
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: CrudStateStatus.error,
          errorMessage: mapError(error),
        ),
      );
    }
  }

  /// Resolves the record identifier used for delete and selection checks.
  String itemId(T item);

  List<T> _replaceItem(List<T> items, T updated) {
    final String updatedId = itemId(updated);
    return items
        .map((T item) => itemId(item) == updatedId ? updated : item)
        .toList(growable: false);
  }

  List<T> _removeItemById(List<T> items, String id) {
    return items
        .where((T item) => itemId(item) != id)
        .toList(growable: false);
  }

  bool _isSelectedId(String id) {
    final T? selected = state.selectedItem;
    if (selected == null) {
      return false;
    }

    return itemId(selected) == id;
  }
}
