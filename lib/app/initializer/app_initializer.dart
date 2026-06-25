import '../../utils/exports.dart';

/// This class initializes all the services and configurations for the application.
class AppInitializer {
  AppInitializer._();

  /// Singleton instance
  static final AppInitializer instance = AppInitializer._();

  /// Initializes the application with necessary services and configurations.
  ///
  /// This method sets up error handling, initializes services, and runs the app.
  ///
  /// [runApp] is a callback to run the Flutter application.
  void init(
    VoidCallback runApp,
  ) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return CustomTextLabelWidget(
        label: errorDetails.exceptionAsString(),
      );
    };
    unawaited(runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (FlutterErrorDetails details) {
        // FirebaseCrashlytics.instance.recordFlutterError;
        FlutterError.dumpErrorToConsole(details);
        DebugLog.instance.e(details.stack.toString());
      };
      await _initServices();
      runApp();
    }, (Object exception, StackTrace stackTrace) async {
      DebugLog.instance.i('runZonedGuarded: \\${exception.toString()}');
      await SentryService.instance
          .captureException(exception, stackTrace: stackTrace);
    }));
  }

  /// Initializes various services required by the application.
  FutureOr<void> _initServices() async {
    try {
      setupLocator();
      await SentryService.instance.init();
      await _getPackageAndDeviceInfo();
      await DebugLog.instance.init();
      await getIt<FirebaseService>().init();
      await getIt<FirebaseService>().configureFirestore();
      await getIt<HiveManager>().init();
      getIt<SyncService>().startListening();
      await getIt<InitializeNotificationsUseCase>()();
      await getIt<RefreshScheduledRemindersUseCase>()();
      await NotificationManager.instance.init();
      await _initStorage();
      _initScreenPreference();
      _setStatusBarTheme();
    } catch (err) {
      DebugLog.instance.e(err.toString());
      rethrow;
    }
  }

  /// Initializes storage services.
  FutureOr<void> _initStorage() async {
    await GetStorage.init();
    SharedPref.instance.init();
  }

  /// Sets the preferred screen orientation.
  void _initScreenPreference() {
    unawaited(SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]));
  }

  /// Customizes the status bar theme.
  void _setStatusBarTheme() {
    SystemChrome.setSystemUIOverlayStyle(MyAppTheme.instance.systemOverlay());
  }

  /// Retrieves package and device information.
  Future<void> _getPackageAndDeviceInfo() async {
    if (kIsWeb) {
      final WebBrowserInfo webDeviceInfo =
          await DeviceInfoPlugin().webBrowserInfo;
      getIt<MainConfig>().webBrowserInfo = webDeviceInfo;
    } else {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidDeviceInfo =
            await DeviceInfoPlugin().androidInfo;
        getIt<MainConfig>().androidInfo = androidDeviceInfo;
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
        getIt<MainConfig>().iosDeviceInfo = iosDeviceInfo;
      }
    }
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    getIt<MainConfig>().packageInfo = packageInfo;
  }
}
