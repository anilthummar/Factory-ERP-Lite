import '../../../utils/exports.dart';

/// Represents the state of the first tab in the application.
///
/// This state is used to manage the user details, error messages,
/// and the current status of the tab.
class TabOneState extends Equatable {
  /// The response containing user details.
  final UserDetailResponse? userDetailResponse;

  /// The error message, if any.
  final String? errorMsg;

  /// The current status of the state.
  final BaseStateStatus status;

  /// Creates a new instance of [TabOneState].
  ///
  /// The [status] parameter defaults to [BaseStateStatus.initial].
  const TabOneState({
    this.userDetailResponse,
    this.errorMsg,
    this.status = BaseStateStatus.initial,
  });

  @override
  List<dynamic> get props => <dynamic>[userDetailResponse, errorMsg, status];

  /// Creates a copy of this state with the given fields replaced with new values.
  TabOneState copyWith(
    BaseStateStatus status, {
    UserDetailResponse? userDetailResponse,
    String? errorMsg,
  }) {
    return TabOneState(
      status: status,
      userDetailResponse: userDetailResponse ?? this.userDetailResponse,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
