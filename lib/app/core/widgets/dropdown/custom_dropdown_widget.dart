import '../../../../utils/exports.dart';

/// A custom dropdown widget that allows selection from a list of items.
///
/// This widget provides a dropdown menu with customizable options for
/// displaying labels and handling selection changes.
class CustomDropDownWidget<T> extends StatelessWidget {
  /// The list of items to display in the dropdown menu.
  final List<T> list;

  /// The currently selected value in the dropdown menu.
  final T value;

  /// A function that returns the label for each item in the dropdown menu.
  final String Function(T) label;

  /// Whether the dropdown menu should be expanded to fill available space.
  final bool? isExpanded;

  /// Creates a custom dropdown widget.
  const CustomDropDownWidget({
    super.key,
    required this.list,
    required this.value,
    required this.label,
    this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.instance.lightGrayBGColor),
          borderRadius: Dimens.radius4.borderRadius),
      // padding: const EdgeInsets.only(left: Dimens.padding14, right: Dimens.padding14),
      child: DropdownButton<T>(
        padding: EdgeInsets.zero,
        dropdownColor: AppColors.instance.whiteBGColor,
        value: value,
        isExpanded: isExpanded ?? false,
        underline: const SizedBox(),
        elevation: Dimens.elevation2.toInt(),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.instance.lightGrayBGColor,
        ),
        onChanged: (T? newValue) {},
        items: list.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Padding(
              padding: Dimens.padding14.padding,
              child: CustomTextLabelWidget(label: label(value)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
