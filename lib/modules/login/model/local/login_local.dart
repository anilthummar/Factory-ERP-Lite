import '../../../../utils/exports.dart';

part 'login_local.freezed.dart';
part 'login_local.g.dart';

/// A data class representing local login information.
///
/// This class is used to store login details such as email and password.
@freezed
class LoginLocal with _$LoginLocal {
  /// Creates a new instance of [LoginLocal].
  const factory LoginLocal({String? email, String? password}) = _LoginLocal;

  /// Creates a new instance of [LoginLocal] from a JSON object.
  factory LoginLocal.fromJson(Map<String, dynamic> json) =>
      _$LoginLocalFromJson(json);
}
