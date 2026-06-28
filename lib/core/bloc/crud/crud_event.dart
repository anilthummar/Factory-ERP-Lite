import 'package:equatable/equatable.dart';

/// Base event type for generic CRUD BLoCs.
sealed class CrudEvent<T> extends Equatable {
  /// Creates [CrudEvent].
  const CrudEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads all records.
final class CrudLoadEvent<T> extends CrudEvent<T> {
  /// Creates [CrudLoadEvent].
  const CrudLoadEvent();
}

/// Reloads all records (pull-to-refresh).
final class CrudRefreshEvent<T> extends CrudEvent<T> {
  /// Creates [CrudRefreshEvent].
  const CrudRefreshEvent();
}

/// Creates a new record.
final class CrudCreateEvent<T> extends CrudEvent<T> {
  /// Creates [CrudCreateEvent].
  const CrudCreateEvent(this.item);

  /// Record to create.
  final T item;

  @override
  List<Object?> get props => <Object?>[item];
}

/// Updates an existing record.
final class CrudUpdateEvent<T> extends CrudEvent<T> {
  /// Creates [CrudUpdateEvent].
  const CrudUpdateEvent(this.item);

  /// Record to update.
  final T item;

  @override
  List<Object?> get props => <Object?>[item];
}

/// Deletes a record by identifier.
final class CrudDeleteEvent<T> extends CrudEvent<T> {
  /// Creates [CrudDeleteEvent].
  const CrudDeleteEvent(this.id);

  /// Identifier of the record to delete.
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

/// Selects a record for detail or edit flows.
final class CrudSelectEvent<T> extends CrudEvent<T> {
  /// Creates [CrudSelectEvent].
  const CrudSelectEvent(this.item);

  /// Selected record.
  final T item;

  @override
  List<Object?> get props => <Object?>[item];
}

/// Clears the current selection.
final class CrudClearSelectionEvent<T> extends CrudEvent<T> {
  /// Creates [CrudClearSelectionEvent].
  const CrudClearSelectionEvent();
}

/// Resets state to initial.
final class CrudResetEvent<T> extends CrudEvent<T> {
  /// Creates [CrudResetEvent].
  const CrudResetEvent();
}
