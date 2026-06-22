import '../../../../utils/exports.dart';

/// An abstract class representing the repository for Tab One.
///
/// This repository defines the contract for fetching user details.
abstract class TabOneRepository extends BaseRepository {
  /// Fetches user details for a given user ID.
  ///
  /// [id] is the unique identifier of the user.
  ///
  /// Returns a [ResponseHandler] containing a [UserDetailResponse].
  Future<ResponseHandler<UserDetailResponse>> getUserDetails({int id});
}
