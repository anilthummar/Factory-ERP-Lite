import '../utils/exports.dart';
import 'auth/web_admin_auth_gate.dart';
import 'shell/web_admin_shell.dart';

/// Root widget for the Factory ERP Lite web admin panel.
class WebAdminApp extends StatelessWidget {
  /// Creates [WebAdminApp].
  const WebAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleBloc>(
      create: (BuildContext context) => getIt<LocaleBloc>(),
      child: BlocBuilder<LocaleBloc, ChangeLocaleState>(
        builder: (BuildContext context, ChangeLocaleState state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Factory ERP Lite Admin',
            theme: MyAppTheme.instance.theme,
            locale: state.locale,
            supportedLocales: const <Locale>[
              Locale(AppConstant.en, ''),
              Locale(AppConstant.hi, ''),
            ],
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (
              Locale? locale,
              Iterable<Locale> supportedLocales,
            ) {
              for (final Locale supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            home: const WebAdminAuthGate(
              child: WebAdminShell(),
            ),
          );
        },
      ),
    );
  }
}
