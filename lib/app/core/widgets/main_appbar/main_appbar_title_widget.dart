import '../../../../../utils/exports.dart';

/// A custom widget to display a title in the app bar.
///
/// This widget includes a back button, title widget, and trailing icons.
class MainAppBarTitleWidget extends StatelessWidget {
  /// The title to display in the app bar.
  final String? title;

  /// Creates a main app bar title widget.
  const MainAppBarTitleWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: title.isNotNullOrEmpty,
      child: CustomTextLabelWidget(
        label: title ?? "",
      ),
    );
  }
}
