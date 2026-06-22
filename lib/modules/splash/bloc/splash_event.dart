import '../../../utils/exports.dart';

/// Base event for splash workflow.
sealed class SplashEvent extends Equatable {
  /// Creates a splash event.
  const SplashEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Triggers splash redirection timer.
class SplashStarted extends SplashEvent {
  /// Creates a start event.
  const SplashStarted();
}
