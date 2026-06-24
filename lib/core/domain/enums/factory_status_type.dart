/// Operating status for factory status records.
enum FactoryStatusType {
  /// Factory is running normally.
  operational,

  /// Factory is under maintenance.
  maintenance,

  /// Factory is shut down.
  shutdown,

  /// Factory is running with limited capacity.
  partial,
}
