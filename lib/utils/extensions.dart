import 'exports.dart';

/// Abstract class for extensions.
abstract class Extensions {}

/// Extension methods for [num] to provide additional utilities.
extension BorderRadiusExt on num {
  /// Returns a [BorderRadius] with circular corners.
  BorderRadius get borderRadius => BorderRadius.circular(toDouble());

  /// Returns a [Radius] with circular corners.
  Radius get circularRadius => Radius.circular(toDouble());

  /// Returns [EdgeInsetsGeometry] with equal padding on all sides.
  EdgeInsetsGeometry get padding => EdgeInsets.all(toDouble());

  /// Returns an [InputBorder] with the specified border side.
  InputBorder outlineInputBorder({
    BorderSide borderSide = BorderSide.none,
  }) =>
      OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: borderSide,
      );

  /// Returns a [BorderSide] with the specified properties.
  BorderSide borderSide({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
  }) =>
      BorderSide(
        color: color ?? AppColors.instance.whiteBGColor,
        width: toDouble(),
        style: style ?? BorderStyle.solid,
        strokeAlign: strokeAlign ?? -1.0,
      );
}

/// Extension methods for [String] to provide additional utilities.
extension HexColorExt on String {
  /// Converts a hex color string to a [Color] object.
  Color get fromHex {
    final StringBuffer buffer = StringBuffer();
    if (length == 6 || length == 7) {
      buffer.write('ff');
    }

    if (startsWith('#')) {
      buffer.write(replaceFirst('#', ''));
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Extension methods for nullable [bool] to provide additional utilities.
extension RxnBoolExt on bool? {
  /// Returns true if the boolean is true.
  bool? get isTrue => this;

  /// Returns false if the boolean is false.
  bool? get isFalse {
    if (this != null) return !isTrue!;
    return null;
  }
}
