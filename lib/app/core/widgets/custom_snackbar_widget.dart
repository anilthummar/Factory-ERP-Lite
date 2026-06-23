import '../../../utils/exports.dart';

/// A custom snack bar widget that displays a message with an optional icon and button.
///
/// This widget is used to show a snack bar with a message, and optionally an icon
/// and a button that can trigger a callback when pressed.
class CustomSnackBarWidget extends StatelessWidget {
  /// The message to display in the snack bar.
  final String message;

  /// An optional icon to display alongside the message.
  final SvgGenImage? icon;

  /// The text to display on the button, if any.
  final String? buttonText;

  /// The callback function to execute when the button is clicked.
  final Function()? onButtonClick;

  /// Creates a custom snack bar widget.
  const CustomSnackBarWidget({
    required this.message,
    this.icon,
    this.buttonText,
    this.onButtonClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: Dimens.padding8),
            child: icon!.svg(
              height: Dimens.size16,
              width: Dimens.size16,
            ),
          ),
        Expanded(
          child: CustomTextLabelWidget(
            textAlign: icon != null ? TextAlign.left : TextAlign.center,
            maxLines: Dimens.maxLines02,
            label: message,
            style: context.textTheme.bodyMedium
                ?.copyWith(fontSize: Dimens.fontSize14),
          ),
        ),
      ],
    );
  }
}

/// Displays a snack bar with the given message and optional parameters.
///
/// [message] - The message to display in the snack bar.
/// [context] - The build context to use for displaying the snack bar.
/// [icon] - An optional icon to display in the snack bar.
/// [buttonText] - The text to display on the button, if any.
/// [onButtonClick] - The callback function to execute when the button is clicked.
/// [duration] - The duration for which the snack bar should be displayed.
/// [isDismissible] - Whether the snack bar can be dismissed by the user.
void displaySnackBar(String message, BuildContext context,
    {SvgGenImage? icon,
    String buttonText = "",
    Function()? onButtonClick,
    Duration? duration,
    bool? isDismissible}) {
  if (message.trim().isEmpty) {
    return;
  }

  context.scaffoldMessenger.clearSnackBars();
  context.scaffoldMessenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(Dimens.padding16),
      duration: duration ?? const Duration(seconds: Dimens.duration3),
      shape: RoundedRectangleBorder(borderRadius: Dimens.radius10.borderRadius),
      content: CustomSnackBarWidget(
        message: message,
        icon: icon,
        buttonText: buttonText,
        onButtonClick: onButtonClick,
      ),
      backgroundColor: AppColors.instance.lightGrayBGColor,
    ),
  );
}

/// Extension on [BuildContext] to show the app snack bar from context.
extension SnackBarContextExtension on BuildContext {
  /// Displays a snack bar with the given message and optional parameters.
  void showAppSnackBar(
    String message, {
    SvgGenImage? icon,
    String buttonText = '',
    void Function()? onButtonClick,
    Duration? duration,
    bool? isDismissible,
  }) {
    displaySnackBar(
      message,
      this,
      icon: icon,
      buttonText: buttonText,
      onButtonClick: onButtonClick,
      duration: duration,
      isDismissible: isDismissible,
    );
  }
}
