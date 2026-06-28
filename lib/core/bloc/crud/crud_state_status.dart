/// Lifecycle states for generic CRUD BLoCs.
enum CrudStateStatus {
  /// Before the first load or after a full reset.
  initial,

  /// A CRUD operation is in progress.
  loading,

  /// Data is available.
  loaded,

  /// Load completed with no records.
  empty,

  /// An operation failed.
  error,
}
