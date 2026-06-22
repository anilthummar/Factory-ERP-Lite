import '../../../utils/exports.dart';

/// A global instance of GetIt for dependency injection.
final GetIt getIt = GetIt.instance;

/// Sets up the service locator for dependency injection.
///
/// This function registers various services and singletons
/// using the GetIt package for dependency management.
void setupLocator() {
  getIt
    ..registerSingleton<AppColors>(AppColors())
    ..registerLazySingleton<DebugLog>(DebugLog.new)
    ..registerLazySingleton<SharedPref>(SharedPref.new)
    ..registerSingleton<MyAppTheme>(MyAppTheme())
    ..registerSingleton<AppRouter>(AppRouter())
    ..registerSingleton<LocaleBloc>(LocaleBloc())
    ..registerSingleton<MainConfig>(MainConfig())
    ..registerSingleton<ApiClient>(ApiClient())
    ..registerLazySingleton<TabOneRepository>(TabOneRepositoryImpl.new)
    ..registerLazySingleton<CustomPaginationRepository>(
      CustomPaginationRepositoryImpl.new,
    )
    ..registerSingleton<AppStyles>(AppStyles())
    ..registerLazySingleton<AESEncryption>(AESEncryption.new)
    ..registerLazySingleton<DefaultFirebaseOptions>(DefaultFirebaseOptions.new)
    ..registerLazySingleton<RegExpressions>(RegExpressions.new)
    ..registerSingleton<ForceUpdateUnderMaintenanceBloc>(
        ForceUpdateUnderMaintenanceBloc());
}
