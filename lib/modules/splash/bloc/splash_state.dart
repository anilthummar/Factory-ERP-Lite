import '../../../utils/exports.dart';

/// Represents the state of the splash screen.
///
/// This state includes the current status of the splash screen.
class SplashState extends Equatable {
  /// The current status of the splash screen.
  final BaseStateStatus status;

  /// Creates a splash state with an optional status.
  const SplashState({
    this.status = BaseStateStatus.initial,
  });

  /// Returns a copy of the current state with updated values.
  SplashState copyWith({BaseStateStatus? status, LoginLocal? loginLocal, bool? onChange}) {
    return SplashState(
      status: status ?? this.status,
    );
  }

  @override
  List<dynamic> get props => <dynamic>[status];
}
