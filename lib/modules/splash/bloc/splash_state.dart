import '../../../utils/exports.dart';

/// Represents the state of the splash screen.
class SplashState extends Equatable {
  /// The current status of the splash screen.
  final BaseStateStatus status;

  /// Destination route after splash completes.
  final String? routeName;

  /// Creates a splash state with an optional status.
  const SplashState({
    this.status = BaseStateStatus.initial,
    this.routeName,
  });

  /// Returns a copy of the current state with updated values.
  SplashState copyWith({
    BaseStateStatus? status,
    String? routeName,
  }) {
    return SplashState(
      status: status ?? this.status,
      routeName: routeName,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, routeName];
}
