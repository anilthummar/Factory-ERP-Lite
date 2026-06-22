import '../../../utils/exports.dart';

/// A bloc for managing the state of Tab One.
///
/// This bloc handles API calls to fetch user details and updates the state accordingly.
class TabOneBloc extends Bloc<TabOneEvent, TabOneState> {
  final TabOneRepository _repository;

  /// Creates an instance of [TabOneBloc].
  ///
  /// Initializes the bloc and triggers an API call to fetch user details.
  TabOneBloc({required TabOneRepository repository})
      : _repository = repository,
        super(const TabOneState()) {
    on<TabOneFetchRequested>(_onFetchRequested);
    add(const TabOneFetchRequested());
  }

  Future<void> _onFetchRequested(
    TabOneFetchRequested event,
    Emitter<TabOneState> emit,
  ) async {
    emit(state.copyWith(BaseStateStatus.loading));
    await _repository.getUserDetails().then((ResponseHandler<UserDetailResponse> value) {
      switch (value) {
        case OnSuccessResponse<UserDetailResponse>():
          {
            emit(TabOneState(
              userDetailResponse: value.getSuccessInstance()?.response,
              status: BaseStateStatus.success,
            ));
          }
        case OnFailureResponse<UserDetailResponse>():
          {
            final String? message =
                value.getFailureInstance()?.error?.errorMessage;
            emit(TabOneState(
              errorMsg: message,
              status: BaseStateStatus.failure,
            ));
          }
      }
    });
  }
}
