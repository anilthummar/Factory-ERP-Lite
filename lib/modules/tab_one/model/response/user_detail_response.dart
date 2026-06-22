// Freezed constructor parameter annotations are required for JSON key mapping.
// ignore_for_file: invalid_annotation_target

import '../../../../utils/exports.dart';

part 'user_detail_response.freezed.dart';

part 'user_detail_response.g.dart';

/// Response model for user detail API endpoint.
///
/// This model represents the complete response structure returned by the user detail API,
/// containing user information and support details.
@freezed
class UserDetailResponse with _$UserDetailResponse {
  /// Creates a [UserDetailResponse] instance.
  ///
  /// [data] - The user detail information
  /// [support] - Support information and links
  const factory UserDetailResponse({
    /// User detail information including personal data
    UserDetail? data,

    /// Support information with helpful links and text
    Support? support,
  }) = _UserDetailResponse;

  /// Creates a [UserDetailResponse] instance from JSON data.
  ///
  /// [json] - Map containing the JSON response data
  /// Returns a [UserDetailResponse] instance with parsed data
  factory UserDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$UserDetailResponseFromJson(json);
}

/// Model representing detailed user information.
///
/// Contains all personal information about a user including
/// identification, contact details, and profile picture.
@freezed
class UserDetail with _$UserDetail {
  /// Creates a [UserDetail] instance.
  ///
  /// [id] - Unique identifier for the user
  /// [email] - User's email address
  /// [firstName] - User's first name
  /// [lastName] - User's last name
  /// [avatar] - URL to user's profile picture
  const factory UserDetail({
    /// Unique identifier for the user
    int? id,

    /// User's email address
    String? email,

    /// User's first name
    @JsonKey(name: 'first_name')
    String? firstName,

    /// User's last name
    @JsonKey(name: 'last_name')
    String? lastName,

    /// URL to user's profile picture/avatar
    String? avatar,
  }) = _UserDetail;

  /// Creates a [UserDetail] instance from JSON data.
  ///
  /// [json] - Map containing the JSON user data
  /// Returns a [UserDetail] instance with parsed user information
  factory UserDetail.fromJson(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);
}

/// Model representing support information.
///
/// Contains support-related information such as help links and descriptive text
/// that can be displayed to users for assistance.
@freezed
class Support with _$Support {
  /// Creates a [Support] instance.
  ///
  /// [url] - Support URL or help link
  /// [text] - Descriptive text about the support
  const factory Support({
    /// Support URL or help link for user assistance
    String? url,

    /// Descriptive text about the support or help information
    String? text,
  }) = _Support;

  /// Creates a [Support] instance from JSON data.
  ///
  /// [json] - Map containing the JSON support data
  /// Returns a [Support] instance with parsed support information
  factory Support.fromJson(Map<String, dynamic> json) =>
      _$SupportFromJson(json);
}
