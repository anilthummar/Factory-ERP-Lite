import '../../../../utils/exports.dart';

/// A page that displays the login form.
///
/// This page provides a [BlocProvider] for the [LoginBloc]
/// and displays the [LoginForm].
@RoutePage()
class LoginPage extends StatelessWidget {
  /// The constructor for [LoginPage].
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (BuildContext ctx) => LoginBloc(),
        child: const LoginForm());
  }
}
