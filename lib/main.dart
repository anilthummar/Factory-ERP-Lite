import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../utils/exports.dart';

///When app is in background this method will be call
@pragma('vm:entry-point')
Future<void> firebaseBackground(RemoteMessage message) async {
  DebugLog.instance
      .i("FCM Background Message : ${message.data} ${message.notification}");
  await AwesomeNotificationManager.instance
      .showNotification(payload: message.data);
}

/// Entry point of the application.
///
/// Initializes the app and sets up necessary configurations.
void main() {
  mainDelegate();
}

/// Delegate function to initialize the app.
///
/// Sets up the app initializer and runs the app with Sentry integration.
void mainDelegate() => AppInitializer.instance.init(
      () async {
        setPathUrlStrategy();
        runApp(SentryWidget(child: const MyApp()));
      },
    );

/// The root widget of the application.
///
/// This widget sets up the app's theme, localization, and routing.
class MyApp extends StatelessWidget {
  /// The constructor for [MyApp].
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<LocaleBloc>(
          create: (BuildContext context) => getIt<LocaleBloc>(),
        ),
        BlocProvider<ForceUpdateUnderMaintenanceBloc>(
          create: (BuildContext context) =>
              getIt<ForceUpdateUnderMaintenanceBloc>(),
        )
      ],
      child: BlocBuilder<LocaleBloc, ChangeLocaleState>(
        builder: (BuildContext context, ChangeLocaleState state) {
          return MaterialApp.router(
            builder: EasyLoading.init(
                builder: (BuildContext context, Widget? child) {
              configLoader();
              return child ?? const SizedBox();
            }),
            routerConfig: getIt<AppRouter>().config(
                navigatorObservers: () => <NavigatorObserver>[
                      CustomNavigationObserver(),
                      SentryNavigatorObserver(),
                    ]),
            title: 'Factory ERP Lite',
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
            localeResolutionCallback:
                (Locale? locale, Iterable<Locale> supportedLocales) {
              for (final Locale supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            theme: MyAppTheme.instance.theme,
          );
        },
        buildWhen: (ChangeLocaleState previous, ChangeLocaleState current) =>
            previous.locale != current.locale,
      ),
    );
  }

  /// Configures the loading indicator settings.
  void configLoader() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: Dimens.timeDuration2000)
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = Dimens.size40
      ..radius = Dimens.radius12
      ..progressWidth = Dimens.borderWidth4
      ..textColor = AppColors.instance.whiteTextColor
      ..progressColor = AppColors.instance.whiteBGColor
      ..backgroundColor = AppColors.instance.orangeBGColor
      ..indicatorColor = AppColors.instance.whiteBGColor
      ..userInteractions = false
      ..dismissOnTap = false;
  }
}
