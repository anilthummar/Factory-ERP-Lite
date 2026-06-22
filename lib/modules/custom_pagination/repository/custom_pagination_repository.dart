import '../../../../utils/exports.dart';

/// An abstract class representing the custom pagination repository.
///
/// This repository defines the contract for fetching paginated data.
abstract class CustomPaginationRepository extends BaseRepository {
  /// Fetches a list of pagination details for a given page.
  ///
  /// [page] is the page number to fetch.
  ///
  /// Returns a [ResponseHandler] containing a list of [PaginationDetailResponse].
  Future<ResponseHandler<List<PaginationDetailResponse>>> getListOfDetails(
      int page);
}
