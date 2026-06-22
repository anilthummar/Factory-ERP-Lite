import '../../../../utils/exports.dart';

/// A form widget for handling user login.
///
/// This widget provides a responsive login form that adapts to mobile, tablet,
/// and desktop layouts.
class LoginForm extends BaseResponsiveView {
  /// Creates a login form widget.
  const LoginForm({super.key});

  @override
  Widget buildTabletWidget(BuildContext context) {
    return _loginForm(context);
  }

  @override
  Widget buildDesktopWidget(BuildContext context) {
    return _loginForm(context);
  }

  @override
  Widget buildMobileWidget(BuildContext context) {
    return _loginForm(context);
  }

  /// Builds the login form widget.
  Widget _loginForm(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state.status == BaseStateStatus.success &&
            state.routeName != null) {
          unawaited(context.router.pushNamed(state.routeName!));
        }
      },
      listenWhen: (LoginState previous, LoginState current) =>
          current.routeName != null,
      child: Padding(
        padding: const EdgeInsets.only(
            left: Dimens.padding16, right: Dimens.padding16),
        child: Form(
          key: context.instance<LoginBloc>().state.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BlocBuilder<LoginBloc, LoginState>(
                builder: (BuildContext ctx, LoginState state) {
                  return CustomTextFormFieldWidget(
                    label: context.appString.emailIdKey,
                    onChange: (String value) {
                      context
                          .read<LoginBloc>()
                          .add(LoginEmailChanged(value));
                    },
                    validator: (dynamic value) {
                      return value.toString().validateEmail(context);
                    },
                  );
                },
                buildWhen: (LoginState previous, LoginState current) =>
                    previous.loginLocal.email != current.loginLocal.email,
              ),
              const SizedBox(
                height: Dimens.space16,
              ),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (BuildContext ctx, LoginState state) {
                  return CustomTextFormFieldWidget(
                    label: context.appString.passwordKey,
                    onChange: (String value) {
                      context
                          .read<LoginBloc>()
                          .add(LoginPasswordChanged(value));
                    },
                    validator: (dynamic value) =>
                        value.toString().validatePassword(context),
                  );
                },
                buildWhen: (LoginState previous, LoginState current) =>
                    previous.loginLocal.password != current.loginLocal.password,
              ),
              const SizedBox(
                height: Dimens.space16,
              ),
              BlocListener<LoginBloc, LoginState>(
                  listener: (BuildContext ctx, LoginState state) {},
                  child: CustomButtonWidget(
                    text: context.appString.loginKey,
                    onClick: () {
                      context.read<LoginBloc>().add(const LoginSubmitted());
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
