/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class $AssetsJsonGen {
  const $AssetsJsonGen();

  /// File path: assets/json/cloud.json
  String get cloud => 'assets/json/cloud.json';

  /// List of all assets
  List<String> get values => [cloud];
}

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/ic_appbar_logo.png
  AssetGenImage get icAppbarLogo =>
      const AssetGenImage('assets/png/ic_appbar_logo.png');

  /// File path: assets/png/ic_small_bubble_bg_left.png
  AssetGenImage get icSmallBubbleBgLeft =>
      const AssetGenImage('assets/png/ic_small_bubble_bg_left.png');

  /// File path: assets/png/ic_small_bubble_bg_right.png
  AssetGenImage get icSmallBubbleBgRight =>
      const AssetGenImage('assets/png/ic_small_bubble_bg_right.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [icAppbarLogo, icSmallBubbleBgLeft, icSmallBubbleBgRight];
}

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// File path: assets/svgs/ic_appbar_logo.svg
  SvgGenImage get icAppbarLogo =>
      const SvgGenImage('assets/svgs/ic_appbar_logo.svg');

  /// File path: assets/svgs/ic_appbar_logo_blue.svg
  SvgGenImage get icAppbarLogoBlue =>
      const SvgGenImage('assets/svgs/ic_appbar_logo_blue.svg');

  /// File path: assets/svgs/ic_big_bubble_bg_right.svg
  SvgGenImage get icBigBubbleBgRight =>
      const SvgGenImage('assets/svgs/ic_big_bubble_bg_right.svg');

  /// File path: assets/svgs/ic_check.svg
  SvgGenImage get icCheck => const SvgGenImage('assets/svgs/ic_check.svg');

  /// File path: assets/svgs/ic_home_tab.svg
  SvgGenImage get icHomeTab => const SvgGenImage('assets/svgs/ic_home_tab.svg');

  /// File path: assets/svgs/ic_loan_selected.svg
  SvgGenImage get icLoanSelected =>
      const SvgGenImage('assets/svgs/ic_loan_selected.svg');

  /// File path: assets/svgs/ic_menu.svg
  SvgGenImage get icMenu => const SvgGenImage('assets/svgs/ic_menu.svg');

  /// File path: assets/svgs/ic_selected_home_tab.svg
  SvgGenImage get icSelectedHomeTab =>
      const SvgGenImage('assets/svgs/ic_selected_home_tab.svg');

  /// File path: assets/svgs/ic_small_bubble_bg_left.svg
  SvgGenImage get icSmallBubbleBgLeft =>
      const SvgGenImage('assets/svgs/ic_small_bubble_bg_left.svg');

  /// File path: assets/svgs/ic_small_bubble_bg_right.svg
  SvgGenImage get icSmallBubbleBgRight =>
      const SvgGenImage('assets/svgs/ic_small_bubble_bg_right.svg');

  /// File path: assets/svgs/ic_splash.svg
  SvgGenImage get icSplash => const SvgGenImage('assets/svgs/ic_splash.svg');

  /// File path: assets/svgs/ic_verified_success.svg
  SvgGenImage get icVerifiedSuccess =>
      const SvgGenImage('assets/svgs/ic_verified_success.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        icAppbarLogo,
        icAppbarLogoBlue,
        icBigBubbleBgRight,
        icCheck,
        icHomeTab,
        icLoanSelected,
        icMenu,
        icSelectedHomeTab,
        icSmallBubbleBgLeft,
        icSmallBubbleBgRight,
        icSplash,
        icVerifiedSuccess
      ];
}

class $AssetsWebpGen {
  const $AssetsWebpGen();

  /// File path: assets/webp/ic_apply_loan_banner.webp
  AssetGenImage get icApplyLoanBanner =>
      const AssetGenImage('assets/webp/ic_apply_loan_banner.webp');

  /// File path: assets/webp/ic_cibil_banner.webp
  AssetGenImage get icCibilBanner =>
      const AssetGenImage('assets/webp/ic_cibil_banner.webp');

  /// File path: assets/webp/ic_emi_banner.webp
  AssetGenImage get icEmiBanner =>
      const AssetGenImage('assets/webp/ic_emi_banner.webp');

  /// File path: assets/webp/ic_next.webp
  AssetGenImage get icNext => const AssetGenImage('assets/webp/ic_next.webp');

  /// List of all assets
  List<AssetGenImage> get values =>
      [icApplyLoanBanner, icCibilBanner, icEmiBanner, icNext];
}

class Assets {
  Assets._();

  static const $AssetsJsonGen json = $AssetsJsonGen();
  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();
  static const $AssetsWebpGen webp = $AssetsWebpGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final BytesLoader loader;
    if (_isVecFormat) {
      loader = AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
