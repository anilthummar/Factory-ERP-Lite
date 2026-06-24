import '../../../utils/exports.dart';
import '../../core/domain/repositories/dashboard_repository.dart';
import '../../core/domain/repositories/factory_status_repository.dart';
import '../../core/domain/repositories/labor_repository.dart';
import '../../core/domain/repositories/person_repository.dart';
import '../../core/domain/repositories/recurring_expense_repository.dart';

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
    ..registerLazySingleton<GoogleSignIn>(
      () => GoogleSignIn(
        scopes: <String>['email', 'profile'],
        serverClientId: configGoogleWebClientId,
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        firebaseService: getIt<FirebaseService>(),
        googleSignIn: getIt<GoogleSignIn>(),
      ),
    )
    ..registerSingleton<AppStyles>(AppStyles())
    ..registerLazySingleton<AESEncryption>(AESEncryption.new)
    ..registerLazySingleton<DefaultFirebaseOptions>(DefaultFirebaseOptions.new)
    ..registerLazySingleton<FirebaseService>(
      () => FirebaseService(getIt<DefaultFirebaseOptions>()),
    )
    ..registerLazySingleton<HiveManager>(() => HiveManager.instance)
    ..registerLazySingleton<SyncQueueLocalDataSource>(
      SyncQueueLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<SyncQueueRepository>(
      () => SyncQueueRepositoryImpl(
        localDataSource: getIt<SyncQueueLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<SyncRemoteDataSource>(
      () => FirestoreSyncRemoteDataSource(
        firebaseService: getIt<FirebaseService>(),
      ),
    )
    ..registerLazySingleton<SyncHandlerRegistry>(
      () => createDefaultSyncHandlerRegistry(hiveManager: getIt<HiveManager>()),
    )
    ..registerLazySingleton<SyncEngine>(
      () => SyncEngine(
        queueRepository: getIt<SyncQueueRepository>(),
        remoteDataSource: getIt<SyncRemoteDataSource>(),
        handlerRegistry: getIt<SyncHandlerRegistry>(),
        hiveManager: getIt<HiveManager>(),
        debugLog: getIt<DebugLog>(),
      ),
    )
    ..registerLazySingleton<SyncCoordinator>(
      () => SyncCoordinator(
        queueRepository: getIt<SyncQueueRepository>(),
        syncEngine: getIt<SyncEngine>(),
      ),
    )
    ..registerLazySingleton<OfflineFirstSyncSupport>(
      () => OfflineFirstSyncSupport(getIt<SyncCoordinator>()),
    )
    ..registerLazySingleton<SyncService>(
      () => SyncService(
        hiveManager: getIt<HiveManager>(),
        syncEngine: getIt<SyncEngine>(),
        queueRepository: getIt<SyncQueueRepository>(),
      ),
    )
    ..registerLazySingleton<PersonLocalDataSource>(
      PersonLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<PersonRepository>(
      () => PersonRepositoryImpl(
        localDataSource: getIt<PersonLocalDataSource>(),
        syncSupport: getIt<OfflineFirstSyncSupport>(),
      ),
    )
    ..registerLazySingleton<GetPersonsUseCase>(
      () => GetPersonsUseCase(getIt<PersonRepository>()),
    )
    ..registerLazySingleton<AddPersonUseCase>(
      () => AddPersonUseCase(getIt<PersonRepository>()),
    )
    ..registerLazySingleton<UpdatePersonUseCase>(
      () => UpdatePersonUseCase(getIt<PersonRepository>()),
    )
    ..registerLazySingleton<DeletePersonUseCase>(
      () => DeletePersonUseCase(getIt<PersonRepository>()),
    )
    ..registerLazySingleton<SearchPersonsUseCase>(
      () => SearchPersonsUseCase(getIt<PersonRepository>()),
    )
    ..registerLazySingleton<LaborLocalDataSource>(
      LaborLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<LaborRepository>(
      () => LaborRepositoryImpl(
        localDataSource: getIt<LaborLocalDataSource>(),
        syncSupport: getIt<OfflineFirstSyncSupport>(),
      ),
    )
    ..registerLazySingleton<GetLaborUseCase>(
      () => GetLaborUseCase(getIt<LaborRepository>()),
    )
    ..registerLazySingleton<AddLaborUseCase>(
      () => AddLaborUseCase(getIt<LaborRepository>()),
    )
    ..registerLazySingleton<UpdateLaborUseCase>(
      () => UpdateLaborUseCase(getIt<LaborRepository>()),
    )
    ..registerLazySingleton<DeleteLaborUseCase>(
      () => DeleteLaborUseCase(getIt<LaborRepository>()),
    )
    ..registerLazySingleton<SearchLaborUseCase>(
      () => SearchLaborUseCase(getIt<LaborRepository>()),
    )
    ..registerLazySingleton<MaterialPurchaseLocalDataSource>(
      MaterialPurchaseLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<MaterialPurchaseRepository>(
      () => MaterialPurchaseRepositoryImpl(
        localDataSource: getIt<MaterialPurchaseLocalDataSource>(),
        syncSupport: getIt<OfflineFirstSyncSupport>(),
      ),
    )
    ..registerLazySingleton<GetMaterialPurchasesUseCase>(
      () => GetMaterialPurchasesUseCase(getIt<MaterialPurchaseRepository>()),
    )
    ..registerLazySingleton<AddMaterialPurchaseUseCase>(
      () => AddMaterialPurchaseUseCase(getIt<MaterialPurchaseRepository>()),
    )
    ..registerLazySingleton<UpdateMaterialPurchaseUseCase>(
      () => UpdateMaterialPurchaseUseCase(getIt<MaterialPurchaseRepository>()),
    )
    ..registerLazySingleton<DeleteMaterialPurchaseUseCase>(
      () => DeleteMaterialPurchaseUseCase(getIt<MaterialPurchaseRepository>()),
    )
    ..registerLazySingleton<SearchMaterialPurchasesUseCase>(
      () => SearchMaterialPurchasesUseCase(getIt<MaterialPurchaseRepository>()),
    )
    ..registerLazySingleton<TruckExpenseLocalDataSource>(
      TruckExpenseLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<TruckExpenseRepository>(
      () => TruckExpenseRepositoryImpl(
        localDataSource: getIt<TruckExpenseLocalDataSource>(),
        syncSupport: getIt<OfflineFirstSyncSupport>(),
      ),
    )
    ..registerLazySingleton<GetTruckExpensesUseCase>(
      () => GetTruckExpensesUseCase(getIt<TruckExpenseRepository>()),
    )
    ..registerLazySingleton<AddTruckExpenseUseCase>(
      () => AddTruckExpenseUseCase(getIt<TruckExpenseRepository>()),
    )
    ..registerLazySingleton<UpdateTruckExpenseUseCase>(
      () => UpdateTruckExpenseUseCase(getIt<TruckExpenseRepository>()),
    )
    ..registerLazySingleton<DeleteTruckExpenseUseCase>(
      () => DeleteTruckExpenseUseCase(getIt<TruckExpenseRepository>()),
    )
    ..registerLazySingleton<SearchTruckExpensesUseCase>(
      () => SearchTruckExpensesUseCase(getIt<TruckExpenseRepository>()),
    )
    ..registerLazySingleton<MaintenanceExpenseLocalDataSource>(
      MaintenanceExpenseLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<MaintenanceExpenseRepository>(
      () => MaintenanceExpenseRepositoryImpl(
        localDataSource: getIt<MaintenanceExpenseLocalDataSource>(),
        syncSupport: getIt<OfflineFirstSyncSupport>(),
      ),
    )
    ..registerLazySingleton<GetMaintenanceExpensesUseCase>(
      () => GetMaintenanceExpensesUseCase(getIt<MaintenanceExpenseRepository>()),
    )
    ..registerLazySingleton<AddMaintenanceExpenseUseCase>(
      () => AddMaintenanceExpenseUseCase(getIt<MaintenanceExpenseRepository>()),
    )
    ..registerLazySingleton<UpdateMaintenanceExpenseUseCase>(
      () =>
          UpdateMaintenanceExpenseUseCase(getIt<MaintenanceExpenseRepository>()),
    )
    ..registerLazySingleton<DeleteMaintenanceExpenseUseCase>(
      () =>
          DeleteMaintenanceExpenseUseCase(getIt<MaintenanceExpenseRepository>()),
    )
    ..registerLazySingleton<SearchMaintenanceExpensesUseCase>(
      () =>
          SearchMaintenanceExpensesUseCase(getIt<MaintenanceExpenseRepository>()),
    )
    ..registerLazySingleton<ElectricityExpenseLocalDataSource>(
      ElectricityExpenseLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<ElectricityExpenseRepository>(
      () => ElectricityExpenseRepositoryImpl(
        localDataSource: getIt<ElectricityExpenseLocalDataSource>(),
        syncSupport: getIt<OfflineFirstSyncSupport>(),
      ),
    )
    ..registerLazySingleton<GetElectricityExpensesUseCase>(
      () => GetElectricityExpensesUseCase(getIt<ElectricityExpenseRepository>()),
    )
    ..registerLazySingleton<AddElectricityExpenseUseCase>(
      () => AddElectricityExpenseUseCase(getIt<ElectricityExpenseRepository>()),
    )
    ..registerLazySingleton<UpdateElectricityExpenseUseCase>(
      () =>
          UpdateElectricityExpenseUseCase(getIt<ElectricityExpenseRepository>()),
    )
    ..registerLazySingleton<DeleteElectricityExpenseUseCase>(
      () =>
          DeleteElectricityExpenseUseCase(getIt<ElectricityExpenseRepository>()),
    )
    ..registerLazySingleton<SearchElectricityExpensesUseCase>(
      () =>
          SearchElectricityExpensesUseCase(getIt<ElectricityExpenseRepository>()),
    )
    ..registerLazySingleton<MiscellaneousExpenseLocalDataSource>(
      MiscellaneousExpenseLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<MiscellaneousExpenseRepository>(
      () => MiscellaneousExpenseRepositoryImpl(
        localDataSource: getIt<MiscellaneousExpenseLocalDataSource>(),
        syncSupport: getIt<OfflineFirstSyncSupport>(),
      ),
    )
    ..registerLazySingleton<GetMiscellaneousExpensesUseCase>(
      () => GetMiscellaneousExpensesUseCase(
        getIt<MiscellaneousExpenseRepository>(),
      ),
    )
    ..registerLazySingleton<AddMiscellaneousExpenseUseCase>(
      () => AddMiscellaneousExpenseUseCase(getIt<MiscellaneousExpenseRepository>()),
    )
    ..registerLazySingleton<UpdateMiscellaneousExpenseUseCase>(
      () => UpdateMiscellaneousExpenseUseCase(
        getIt<MiscellaneousExpenseRepository>(),
      ),
    )
    ..registerLazySingleton<DeleteMiscellaneousExpenseUseCase>(
      () => DeleteMiscellaneousExpenseUseCase(
        getIt<MiscellaneousExpenseRepository>(),
      ),
    )
    ..registerLazySingleton<SearchMiscellaneousExpensesUseCase>(
      () => SearchMiscellaneousExpensesUseCase(
        getIt<MiscellaneousExpenseRepository>(),
      ),
    )
    ..registerLazySingleton<RecurringExpenseLocalDataSource>(
      RecurringExpenseLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<RecurringExpenseRepository>(
      () => RecurringExpenseRepositoryImpl(
        localDataSource: getIt<RecurringExpenseLocalDataSource>(),
        syncSupport: getIt<OfflineFirstSyncSupport>(),
      ),
    )
    ..registerLazySingleton<GetRecurringExpensesUseCase>(
      () => GetRecurringExpensesUseCase(getIt<RecurringExpenseRepository>()),
    )
    ..registerLazySingleton<AddRecurringExpenseUseCase>(
      () => AddRecurringExpenseUseCase(getIt<RecurringExpenseRepository>()),
    )
    ..registerLazySingleton<UpdateRecurringExpenseUseCase>(
      () => UpdateRecurringExpenseUseCase(getIt<RecurringExpenseRepository>()),
    )
    ..registerLazySingleton<DeleteRecurringExpenseUseCase>(
      () => DeleteRecurringExpenseUseCase(getIt<RecurringExpenseRepository>()),
    )
    ..registerLazySingleton<SearchRecurringExpensesUseCase>(
      () => SearchRecurringExpensesUseCase(getIt<RecurringExpenseRepository>()),
    )
    ..registerLazySingleton<FactoryStatusLocalDataSource>(
      FactoryStatusLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<FactoryStatusRepositoryImpl>(
      () => FactoryStatusRepositoryImpl(
        localDataSource: getIt<FactoryStatusLocalDataSource>(),
        syncSupport: getIt<OfflineFirstSyncSupport>(),
      ),
    )
    ..registerLazySingleton<FactoryStatusRepository>(
      () => getIt<FactoryStatusRepositoryImpl>(),
    )
    ..registerLazySingleton<GetCurrentFactoryStatusUseCase>(
      () => GetCurrentFactoryStatusUseCase(getIt<FactoryStatusRepositoryImpl>()),
    )
    ..registerLazySingleton<GetFactoryStatusHistoryUseCase>(
      () => GetFactoryStatusHistoryUseCase(getIt<FactoryStatusRepository>()),
    )
    ..registerLazySingleton<ChangeFactoryStatusUseCase>(
      () => ChangeFactoryStatusUseCase(getIt<FactoryStatusRepositoryImpl>()),
    )
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        personRepository: getIt<PersonRepository>(),
        laborRepository: getIt<LaborRepository>(),
        materialPurchaseRepository: getIt<MaterialPurchaseRepository>(),
        truckExpenseRepository: getIt<TruckExpenseRepository>(),
        maintenanceExpenseRepository: getIt<MaintenanceExpenseRepository>(),
        electricityExpenseRepository: getIt<ElectricityExpenseRepository>(),
        miscellaneousExpenseRepository: getIt<MiscellaneousExpenseRepository>(),
        recurringExpenseRepository: getIt<RecurringExpenseRepository>(),
        factoryStatusRepository: getIt<FactoryStatusRepository>(),
        syncService: getIt<SyncService>(),
      ),
    )
    ..registerLazySingleton<GetDashboardDataUseCase>(
      () => GetDashboardDataUseCase(getIt<DashboardRepository>()),
    )
    ..registerLazySingleton<CalendarRepository>(
      () => CalendarRepositoryImpl(
        recurringExpenseRepository: getIt<RecurringExpenseRepository>(),
        maintenanceExpenseRepository: getIt<MaintenanceExpenseRepository>(),
        factoryStatusRepository: getIt<FactoryStatusRepository>(),
      ),
    )
    ..registerLazySingleton<GetCalendarEventsUseCase>(
      () => GetCalendarEventsUseCase(getIt<CalendarRepository>()),
    )
    ..registerLazySingleton<SyncDiagnosticsRepository>(
      () => SyncDiagnosticsRepositoryImpl(
        queueRepository: getIt<SyncQueueRepository>(),
        syncService: getIt<SyncService>(),
      ),
    )
    ..registerLazySingleton<GetSyncDiagnosticsUseCase>(
      () => GetSyncDiagnosticsUseCase(getIt<SyncDiagnosticsRepository>()),
    )
    ..registerLazySingleton<RetrySyncUseCase>(
      () => RetrySyncUseCase(getIt<SyncDiagnosticsRepository>()),
    )
    ..registerLazySingleton<RegExpressions>(RegExpressions.new)
    ..registerSingleton<ForceUpdateUnderMaintenanceBloc>(
        ForceUpdateUnderMaintenanceBloc());
}
