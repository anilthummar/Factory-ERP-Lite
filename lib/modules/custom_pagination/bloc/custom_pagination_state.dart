import '../../../utils/exports.dart';

/// Represents the state of the custom pagination feature.
///
/// This state includes the current status, pagination data, and scroll controller.
class CustomPaginationState extends Equatable {
  /// The current status of the pagination.
  final BaseStateStatus status;

  /// The local pagination data.
  final PaginationLocal paginationLocal;

  /// The scroll controller for managing scroll events.
  final ScrollController scrollController;

  /// Creates a custom pagination state.
  const CustomPaginationState({
    this.status = BaseStateStatus.initial,
    required this.scrollController,
    this.paginationLocal = const PaginationLocal(),
  });

  /// Returns a copy of the current state with updated values.
  CustomPaginationState copyWith({BaseStateStatus? status, PaginationLocal? paginationLocal}) {
    return CustomPaginationState(
      status: status ?? this.status,
      scrollController: scrollController,
      paginationLocal: paginationLocal ?? this.paginationLocal,
    );
  }

  @override
  List<dynamic> get props => <dynamic>[status, paginationLocal, scrollController];
}
