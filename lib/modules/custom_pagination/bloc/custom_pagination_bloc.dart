import '../../../utils/exports.dart';

/// A bloc for managing pagination state and logic.
///
/// This bloc handles pagination by listening to scroll events
/// and fetching data as needed.
class CustomPaginationBloc extends Bloc<CustomPaginationEvent, CustomPaginationState> {
  final CustomPaginationRepository _repository;

  /// Creates an instance of [CustomPaginationBloc].
  ///
  /// Initializes the bloc with a scroll controller and fetches initial data.
  CustomPaginationBloc({required CustomPaginationRepository repository})
      : _repository = repository,
        super(CustomPaginationState(scrollController: ScrollController())) {
    on<CustomPaginationInitialFetchRequested>(_onInitialFetchRequested);
    on<CustomPaginationLoadMoreRequested>(_onLoadMoreRequested);
    on<CustomPaginationRefreshRequested>(_onRefreshRequested);

    state.scrollController.addListener(_scrollListener);
    add(const CustomPaginationInitialFetchRequested());
  }

  /// Listens for scroll events to trigger pagination.
  void _scrollListener() {
    if (state.scrollController.position.pixels >=
        state.scrollController.position.maxScrollExtent - 100) {
      if ((state.paginationLocal.isRequiredLoadMore ?? false) &&
          state.status != BaseStateStatus.loading) {
        add(const CustomPaginationLoadMoreRequested());
      }
    }
  }

  Future<void> _onInitialFetchRequested(
    CustomPaginationInitialFetchRequested event,
    Emitter<CustomPaginationState> emit,
  ) async {
    await _fetchData(false, emit: emit);
  }

  Future<void> _onLoadMoreRequested(
    CustomPaginationLoadMoreRequested event,
    Emitter<CustomPaginationState> emit,
  ) async {
    await _fetchData(true, emit: emit);
  }

  Future<void> _onRefreshRequested(
    CustomPaginationRefreshRequested event,
    Emitter<CustomPaginationState> emit,
  ) async {
    await _fetchData(false, page: 1, emit: emit);
  }

  /// Refreshes the data by fetching the first page.
  Future<void> handleRefresh() async {
    add(const CustomPaginationRefreshRequested());
  }

  @override
  Future<void> close() {
    state.scrollController.dispose();
    return super.close();
  }

  /// Fetches data from the repository and updates the state.
  ///
  /// [isLoadMore] indicates if more data should be loaded.
  /// [page] specifies the page number to fetch.
  Future<void> _fetchData(
    bool isLoadMore, {
    int? page,
    required Emitter<CustomPaginationState> emit,
  }) async {
    emit(state.copyWith(
      status: BaseStateStatus.loading,
      paginationLocal: state.paginationLocal.copyWith(isLoadMore: isLoadMore),
    ));
    try {
      int currentPage = page ?? state.paginationLocal.page ?? 1;
      await _repository
          .getListOfDetails(currentPage)
          .then((ResponseHandler<List<PaginationDetailResponse>> value) {
        switch (value) {
          case OnSuccessResponse<List<PaginationDetailResponse>>():
            {
              final List<PaginationDetailResponse> responseData = value.response;
              List<PaginationDetailResponse> list =
                  state.paginationLocal.data == null ||
                          (state.paginationLocal.data ?? <PaginationDetailResponse>[]).isEmpty
                      ? responseData
                      : state.paginationLocal.data! + responseData;
              emit(state.copyWith(
                status: BaseStateStatus.success,
                paginationLocal: state.paginationLocal.copyWith(
                  isLoadMore: false,
                  data: list,
                  page: currentPage + 1,
                  isRequiredLoadMore: responseData.isNotEmpty,
                ),
              ));
              if (state.scrollController.hasClients && currentPage != 1) {
                state.scrollController.jumpTo(state.scrollController.position.maxScrollExtent - 200);
              }
            }
          case OnFailureResponse<List<PaginationDetailResponse>>():
            {
              emit(state.copyWith(
                status: BaseStateStatus.failure,
                paginationLocal: state.paginationLocal.copyWith(isLoadMore: false),
              ));
            }
        }
      });
    } on Exception {
      emit(state.copyWith(
        status: BaseStateStatus.failure,
        paginationLocal: state.paginationLocal.copyWith(isLoadMore: false),
      ));
    }
  }
}
