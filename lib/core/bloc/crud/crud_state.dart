import 'package:equatable/equatable.dart';

import 'crud_state_status.dart';

/// Generic list/detail state for CRUD feature BLoCs.
class CrudState<T> extends Equatable {
  /// Creates [CrudState].
  CrudState({
    this.status = CrudStateStatus.initial,
    List<T>? items,
    this.selectedItem,
    this.errorMessage,
  }) : items = items ?? <T>[];

  /// Current CRUD lifecycle status.
  final CrudStateStatus status;

  /// Loaded records for list screens.
  final List<T> items;

  /// Optional selected or edited record.
  final T? selectedItem;

  /// User-facing or debug error message when [status] is [CrudStateStatus.error].
  final String? errorMessage;

  /// Whether [status] is [CrudStateStatus.initial].
  bool get isInitial => status == CrudStateStatus.initial;

  /// Whether [status] is [CrudStateStatus.loading].
  bool get isLoading => status == CrudStateStatus.loading;

  /// Whether [status] is [CrudStateStatus.loaded].
  bool get isLoaded => status == CrudStateStatus.loaded;

  /// Whether [status] is [CrudStateStatus.empty].
  bool get isEmpty => status == CrudStateStatus.empty;

  /// Whether [status] is [CrudStateStatus.error].
  bool get isError => status == CrudStateStatus.error;

  /// Returns a copy with the given fields replaced.
  CrudState<T> copyWith({
    CrudStateStatus? status,
    List<T>? items,
    T? selectedItem,
    String? errorMessage,
    bool clearError = false,
    bool clearSelectedItem = false,
  }) {
    return CrudState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedItem:
          clearSelectedItem ? null : (selectedItem ?? this.selectedItem),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        items,
        selectedItem,
        errorMessage,
      ];
}

/// Emits [CrudStateStatus.loaded] or [CrudStateStatus.empty] from [items].
CrudState<T> crudStateFromItems<T>(List<T> items) {
  if (items.isEmpty) {
    return CrudState<T>(status: CrudStateStatus.empty, items: items);
  }

  return CrudState<T>(status: CrudStateStatus.loaded, items: items);
}
