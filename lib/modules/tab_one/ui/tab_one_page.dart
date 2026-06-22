import '../../../../utils/exports.dart';

/// A page that displays the content for Tab One.
///
/// This page provides a [BlocProvider] for the [TabOneBloc]
/// and displays the [TabOneSuccessWidget].
@RoutePage()
class TabOnePage extends StatelessWidget {
  /// The constructor for [TabOnePage].
  const TabOnePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabOneBloc>(
        create: (BuildContext c) => TabOneBloc(repository: getIt<TabOneRepository>()),
        child: const TabOneSuccessWidget());
  }
}
