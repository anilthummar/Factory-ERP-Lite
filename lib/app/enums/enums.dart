export 'sync_status.dart';

/// Defines the available application environments.
enum Environment {
  /// Staging environment used for testing.
  stage,

  /// Production environment used by end users.
  production,
}

/// Defines the types of API requests.
enum ApiType {
  /// HTTP GET request.
  get,

  /// HTTP POST request.
  post,

  /// HTTP DELETE request.
  delete,
}

/// Represents the status of a base state in a typical UI state management scenario.
enum BaseStateStatus {
  /// Initial state before any action is taken.
  initial,

  /// Indicates that a process is currently loading.
  loading,

  /// Indicates that the process completed successfully.
  success,

  /// Indicates that the process failed.
  failure,
}

/// Enum representing the type of maintenance message to show.
enum UnderMaintenanceType {
  /// No maintenance message.
  none(0),

  /// Text-based maintenance message.
  text(1),

  /// Image-based maintenance message.
  image(2);

  /// Integer representation of the maintenance type.
  final int type;

  /// Constructor to associate enum values with an integer type.
  const UnderMaintenanceType(this.type);
}

/// Enum representing the type of update/maintenance requirement.
enum UpdateMaintenanceType {
  /// App is under maintenance.
  maintenance,

  /// No update or maintenance required.
  none,

  /// A mandatory update is required.
  force,

  /// An optional update is available.
  optional;

  /// Const constructor.
  const UpdateMaintenanceType();
}
