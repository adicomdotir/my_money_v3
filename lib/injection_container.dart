import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lib.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initExternalDependencies();
  _initDataSourceDependencies();
  _initRepositoryDependencies();
  _initUseCaseDependencies();
  _initBlocDependencies();
}

Future<void> _initExternalDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DatabaseHelper());
}

void _initDataSourceDependencies() {
  // Data Sources
  sl.registerLazySingleton<HomeInfoLocalDataSource>(
    () => HomeInfoLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<SplashLocalDataSource>(
    () => SplashLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<ReportDataSource>(
    () => ReportDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<SettingsDataSource>(
    () => SettingsDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<FilterExpenseLocalDataSource>(
    () => FilterExpenseLocalDataSourceImpl(databaseHelper: sl()),
  );
}

void _initRepositoryDependencies() {
  // Repository
  sl.registerLazySingleton<HomeInfoRepository>(
    () => HomeInfoRepositoryImpl(
      homeInfoLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(splashLocalDataSource: sl()),
  );
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
      expenseLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(categoryLocalDataSource: sl()),
  );
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(reportDataSource: sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(settingsDataSource: sl()),
  );
  sl.registerLazySingleton<FilterExpenseRepository>(
    () => FilterExpenseRepositoryImpl(dataSource: sl()),
  );
}

void _initUseCaseDependencies() {
  // Use cases
  sl.registerLazySingleton<GetHomeInfo>(
    () => GetHomeInfo(homeInfoRepository: sl()),
  );
  sl.registerLazySingleton<GetBackup>(
    () => GetBackup(homeInfoRepository: sl()),
  );
  sl.registerLazySingleton<InitializeAppUseCase>(
    () => InitializeAppUseCase(splashRepository: sl()),
  );
  sl.registerLazySingleton<GetSavedLangUseCase>(
    () => GetSavedLangUseCase(settingsRepository: sl()),
  );
  sl.registerLazySingleton<ChangeLangUseCase>(
    () => ChangeLangUseCase(settingsRepository: sl()),
  );
  sl.registerLazySingleton<AddCategoryUseCase>(
    () => AddCategoryUseCase(categoryRepository: sl()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(categoryRepository: sl()),
  );
  sl.registerLazySingleton<AddEditExpenseUseCase>(
    () => AddEditExpenseUseCase(expenseRepository: sl()),
  );
  sl.registerLazySingleton<ExpenseListUseCase>(
    () => ExpenseListUseCase(expenseRepository: sl()),
  );
  sl.registerLazySingleton<DeleteExpenseUseCase>(
    () => DeleteExpenseUseCase(expenseRepository: sl()),
  );
  sl.registerLazySingleton<CategoryListUseCase>(
    () => CategoryListUseCase(categoryRepository: sl()),
  );
  sl.registerLazySingleton<DeleteCategoryUseCase>(
    () => DeleteCategoryUseCase(categoryRepository: sl()),
  );
  sl.registerLazySingleton<GetReportUseCase>(
    () => GetReportUseCase(reportRepository: sl()),
  );
  sl.registerLazySingleton<GetSavedSettingsUseCase>(
    () => GetSavedSettingsUseCase(settingsRepository: sl()),
  );
  sl.registerLazySingleton<ChangeMoneyUnit>(
    () => ChangeMoneyUnit(settingsRepository: sl()),
  );
  sl.registerLazySingleton<GetFilterExpenseUseCase>(
    () => GetFilterExpenseUseCase(repository: sl()),
  );
  sl.registerLazySingleton<SaveUserThemeUsecase>(
    () => SaveUserThemeUsecase(settingsRepository: sl()),
  );
}

void _initBlocDependencies() {
  // Blocs
  sl.registerFactory<HomeInfoCubit>(
    () => HomeInfoCubit(getHomeInfoUseCase: sl()),
  );
  sl.registerFactory<HomeDrawerCubit>(
    () => HomeDrawerCubit(getBackupUseCase: sl()),
  );
  sl.registerFactory<CategoryCubit>(
    () => CategoryCubit(
      addCategoryUseCase: sl(),
      categoryListUseCase: sl(),
      deleteCategoryUseCase: sl(),
    ),
  );
  sl.registerFactory<ExpenseCubit>(
    () => ExpenseCubit(
      expenseListUseCase: sl(),
      deleteExpenseUseCase: sl(),
    ),
  );
  sl.registerFactory<CategoryDropdownCubit>(
    () => CategoryDropdownCubit(categoryListUseCase: sl()),
  );
  sl.registerFactory<ReportBloc>(
    () => ReportBloc(getReportUseCase: sl()),
  );
  sl.registerFactory<GlobalBloc>(
    () => GlobalBloc(getSavedSettingsUseCase: sl()),
  );
  sl.registerFactory<AddEditExpenseCubit>(
    () => AddEditExpenseCubit(addEditExpenseUseCase: sl()),
  );
  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(changeMoneyUnit: sl(), saveUserThemeUsecase: sl()),
  );
  sl.registerFactory<FilterExpneseBloc>(
    () => FilterExpneseBloc(sl()),
  );
  sl.registerFactory<SplashBloc>(
    () => SplashBloc(initializeAppUseCase: sl()),
  );
}
