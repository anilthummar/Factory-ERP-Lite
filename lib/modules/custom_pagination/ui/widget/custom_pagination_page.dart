import '../../../../utils/exports.dart';

/// A page that displays the custom pagination list.
///
/// This page provides a [BlocProvider] for the [CustomPaginationBloc]
/// and displays the [CustomPaginationListWidget].
@RoutePage()
class CustomPaginationPage extends StatelessWidget {
  /// The constructor for [CustomPaginationPage].
  const CustomPaginationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomPaginationBloc>(
        create: (BuildContext ctx) =>
            CustomPaginationBloc(repository: getIt<CustomPaginationRepository>()),
        child: const CustomPaginationListWidget());
  }
}
