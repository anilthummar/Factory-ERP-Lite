/// Progress update during backup or restore operations.
class BackupProgress {
  /// Creates [BackupProgress].
  const BackupProgress({
    required this.stage,
    required this.completedSteps,
    required this.totalSteps,
    this.moduleKey,
  });

  /// Current operation stage label.
  final String stage;

  /// Number of completed steps.
  final int completedSteps;

  /// Total steps for the operation.
  final int totalSteps;

  /// Module key currently being processed, if applicable.
  final String? moduleKey;

  /// Progress ratio between 0 and 1.
  double get fraction {
    if (totalSteps <= 0) {
      return 0;
    }
    return completedSteps / totalSteps;
  }
}
