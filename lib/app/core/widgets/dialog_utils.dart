import '../../../utils/exports.dart';

/// A utility widget for displaying customizable dialogs.
///
/// This widget provides a flexible dialog with optional title, message,
/// and action buttons. It supports custom styling and callback functions
/// for button actions.
class DialogUtils extends StatelessWidget {
  /// The message to display in the dialog.
  final String message;

  /// The optional title of the dialog.
  final String? title;

  /// The title of the OK button.
  final String? okBtnTitle;

  /// The title of the Cancel button.
  final String? cancelBtnTitle;

  /// Callback function to execute when the OK button is clicked.
  final Function()? onOkClicked;

  /// Callback function to execute when the Cancel button is clicked.
  final Function()? onCancelClicked;

  /// Custom text style for the dialog title.
  final TextStyle? titleStyle;

  /// Custom text style for the OK button title.
  final TextStyle? okBtnTitleStyle;

  /// Determines if the dialog should be hidden when a button is clicked.
  /// Defaults to true.
  final bool isDialogHideOnClick;

  /// Creates a dialog utility widget.
  ///
  /// The [message] parameter is required.
  ///
  /// Example:
  /// ```dart
  /// DialogUtils(
  ///   message: 'Are you sure you want to proceed?',
  ///   title: 'Confirmation',
  ///   okBtnTitle: 'Yes',
  ///   cancelBtnTitle: 'No',
  ///   onOkClicked: () => print('OK clicked'),
  ///   onCancelClicked: () => print('Cancel clicked'),
  /// )
  /// ```
  const DialogUtils({
    required this.message,
    this.title,
    this.okBtnTitle,
    this.cancelBtnTitle,
    this.onOkClicked,
    this.isDialogHideOnClick = true,
    this.onCancelClicked,
    super.key,
    this.titleStyle,
    this.okBtnTitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: Dimens.elevation4,
      backgroundColor: AppColors.instance.whiteBGColor,
      shape: RoundedRectangleBorder(borderRadius: Dimens.radius12.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(Dimens.padding10),
        constraints: const BoxConstraints(maxWidth: Dimens.space400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: title.isNotNullOrBlank,
              child: Column(
                children: <Widget>[
                  Text(
                    title ?? '',
                    style:
                        titleStyle ?? context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: Dimens.space12),
                ],
              ),
            ),
            Visibility(
              visible: message.isNotBlank,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Dimens.padding10),
                    child: CustomTextLabelWidget(
                      label: message,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  const SizedBox(
                    height: Dimens.space16,
                    width: Dimens.space28,
                  ),
                ],
              ),
            ),
            if (okBtnTitle.isNotBlank && cancelBtnTitle.isNotBlank)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.padding8),
                      child: CustomButtonWidget(
                        text: cancelBtnTitle ?? "",
                        onClick: () async {
                          if (isDialogHideOnClick) {
                            unawaited(goBack(context));
                          }
                          if (onCancelClicked != null) onCancelClicked?.call();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.padding8),
                      child: CustomButtonWidget(
                        text: okBtnTitle ?? "",
                        onClick: () {
                          if (isDialogHideOnClick) {
                            unawaited(goBack(context));
                          }
                          if (onOkClicked != null) onOkClicked?.call();
                        },
                      ),
                    ),
                  ),
                ],
              )
            else if (okBtnTitle.isNotBlank || cancelBtnTitle.isNotBlank)
              CustomButtonWidget(
                text: okBtnTitle ?? cancelBtnTitle ?? "",
                onClick: () {
                  if (isDialogHideOnClick) {
                    unawaited(goBack(context));
                  }
                  if (onOkClicked != null) onOkClicked?.call();
                  if (onCancelClicked != null) onCancelClicked?.call();
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Displays a custom dialog with the specified message and options.
///
/// This function shows a dialog using [DialogUtils] with optional title,
/// message, and action buttons. It supports custom styling and callback
/// functions for button actions.
///
/// Example:
/// ```dart
/// showCustomDialog(
///   'Are you sure you want to delete this item?',
///   title: 'Delete Confirmation',
///   okBtnTitle: 'Delete',
///   cancelBtnTitle: 'Cancel',
///   onOkClicked: () => print('Item deleted'),
///   onCancelClicked: () => print('Deletion cancelled'),
/// );
/// ```
Future<void> showCustomDialog(
  String message, {
  String? title,
  String? okBtnTitle,
  String? cancelBtnTitle,
  Function()? onOkClicked,
  Function()? onCancelClicked,
  Function(dynamic)? onBack,
  Key? key,
  bool? isDialogHideOnClick,
  TextStyle? titleStyle,
  TextStyle? okBtnTitleStyle,
}) async {
  await showDialog(
      context: MainConfig.context,
      builder: (BuildContext context) {
        return DialogUtils(
          message: message,
          okBtnTitle: okBtnTitle,
          cancelBtnTitle: cancelBtnTitle,
          onOkClicked: onOkClicked,
          isDialogHideOnClick: isDialogHideOnClick ?? false,
          onCancelClicked: onCancelClicked,
          title: title,
          titleStyle: titleStyle,
          okBtnTitleStyle: okBtnTitleStyle,
          key: key,
        );
      }).then((dynamic value) => onBack?.call(value));
}
