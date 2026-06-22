import '../../../../../utils/exports.dart';

/// A widget that displays a loading indicator for pagination.
///
/// This widget is used to show a loading spinner when more data is being loaded.
class CustomPaginationLoaderWidget extends StatelessWidget {
  /// The constructor for [CustomPaginationLoaderWidget].
  const CustomPaginationLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.size50,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
