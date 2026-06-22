import '../../../utils/exports.dart';

/// A widget that displays network images with caching, loading states, and error handling.
///
/// This widget extends the functionality of [CachedNetworkImage] by providing:
/// * Customizable loading indicators
/// * Error handling with fallback images
/// * Image caching for better performance
/// * Customizable styling including borders, shadows, and corner radius
/// * Placeholder support while images load
class CustomNetworkImageWidget extends StatelessWidget {
  /// Creates a custom network image widget.
  ///
  /// The [imageUrl] and [placeHolderImage] parameters are required.
  ///
  /// Example:
  /// ```dart
  /// CustomNetworkImageWidget(
  ///   imageUrl: 'https://example.com/image.jpg',
  ///   placeHolderImage: Assets.images.placeholder,
  ///   width: 100,
  ///   height: 100,
  /// )
  /// ```
  const CustomNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderColor,
    this.color,
    this.shadow,
    this.borderWidth,
    this.radius,
    this.isDownloadPath = true,
    this.isShowPlaceHolder = false,
    required this.placeHolderImage,
    this.alignment = Alignment.center,
  });

  /// The URL of the image to display.
  final String imageUrl;

  /// Optional builder to customize how the image is displayed when loaded.
  final ImageWidgetBuilder? imageBuilder;

  /// Widget to show while the image is loading.
  /// If not provided and [isShowPlaceHolder] is true, [placeHolderImage] will be used.
  final Widget? placeholder;

  /// Builder to create a custom progress indicator while loading.
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  /// Widget to show when there is an error loading the image.
  /// If not provided, [placeHolderImage] will be used.
  final Widget? errorWidget;

  /// Optional box shadow to apply to the image container.
  final List<BoxShadow>? shadow;

  /// The fallback image to display when loading or on error.
  /// This must be an SVG image asset.
  final SvgGenImage placeHolderImage;

  /// The width of the image widget.
  final double? width;

  /// The width of the border around the image.
  final double? borderWidth;

  /// The height of the image widget.
  final double? height;

  /// How the image should be inscribed into the space allocated during layout.
  /// Defaults to [BoxFit.cover].
  final BoxFit? fit;

  /// The color to apply as an overlay to the image container.
  final Color? color;

  /// The color of the border around the image.
  final Color? borderColor;

  /// Whether to show the placeholder while loading.
  /// If true, shows [placeholder] or [placeHolderImage].
  /// If false, shows a circular progress indicator.
  final bool isShowPlaceHolder;

  /// How to align the image within its bounds.
  /// Defaults to [Alignment.center].
  final Alignment alignment;

  /// Whether the image URL is a download path.
  /// This can affect how the URL is processed.
  final bool isDownloadPath;

  /// The border radius of the image container.
  /// Defaults to 4 if not specified.
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: key,
      imageUrl: imageUrl,
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              border: Border.all(
                  color: borderColor ?? AppColors.instance.transparent,
                  width: borderWidth ?? Dimens.borderWidth1),
              color: color,
              borderRadius: (radius ?? Dimens.radius4).borderRadius,
              image: DecorationImage(image: imageProvider, fit: fit),
              boxShadow: shadow),
        );
      },
      placeholder: (BuildContext context, String image) {
        return isShowPlaceHolder
            ? placeholder ??
                _placeHolderWidget(() {
                  return placeHolderImage.svg(fit: BoxFit.fill);
                })
            : const CircularProgressIndicator(
                strokeWidth: Dimens.size50,
              );
      },
      errorWidget: (
        BuildContext context,
        String url,
        dynamic error,
      ) {
        return errorWidget ??
            _placeHolderWidget(() {
              return placeHolderImage.svg(fit: BoxFit.fill);
            });
      },
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }

  /// Creates a container with the specified styling to display placeholder content.
  ///
  /// [child] is a function that returns the widget to display inside the container.
  /// This is typically the [placeHolderImage] SVG.
  Widget _placeHolderWidget(Widget Function() child) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
            color: borderColor ?? AppColors.instance.transparent,
            width: borderWidth ?? Dimens.borderWidth1),
        color: color,
        borderRadius: (radius ?? Dimens.radius4).borderRadius,
      ),
      child: child.call(),
    );
  }
}
