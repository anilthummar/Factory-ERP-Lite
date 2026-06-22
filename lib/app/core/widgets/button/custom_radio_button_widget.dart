import '../../../../utils/exports.dart';

/// A custom radio button widget that allows selection from a group of options.
///
/// This widget is a wrapper around the [RadioListTile] widget, providing
/// additional customization options such as a label.
class CustomRadioButtonWidget extends StatelessWidget {
  /// The value represented by this radio button.
  final dynamic value;

  /// The currently selected value for the group of radio buttons.
  final dynamic groupValue;

  /// The callback function to execute when the radio button is selected.
  final Function(dynamic) onChange;

  /// The label to display next to the radio button.
  final String? label;

  /// Creates a custom radio button widget.
  ///
  /// The [value], [groupValue], and [onChange] parameters are required.
  const CustomRadioButtonWidget({
    super.key,
    required this.value,
    required this.groupValue,
    this.label = "",
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    //ignore: always_specify_types (as this is a flutter default widget)
    return RadioListTile(
      value: value,
      // This remains for backward compatibility until RadioGroup migration.
      // ignore: deprecated_member_use
      groupValue: groupValue,
      // This remains for backward compatibility until RadioGroup migration.
      // ignore: deprecated_member_use
      onChanged: onChange,
      title: CustomTextLabelWidget(
        label: label ?? "",
        textAlign: TextAlign.start,
        style: context.textTheme.bodyMedium,
      ),
    );
  }
}
