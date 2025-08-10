import 'package:get_it/get_it.dart';
import 'package:my_money_v3/core/bloc/global_bloc.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/features/expense/presentation/add_edit_expense/cubit/add_edit_expense_cubit.dart';
import 'package:my_money_v3/features/expense/presentation/expense_list/cubit/expense_cubit.dart';
import 'package:my_money_v3/features/filter_expense/data/datasources/filter_expnese_local_data_source.dart';
import 'package:my_money_v3/features/filter_expense/domain/repositories/filter_expense_repository.dart';
import 'package:my_money_v3/features/filter_expense/domain/usecases/get_filter_expense_use_case.dart';
import 'package:my_money_v3/features/filter_expense/presentation/bloc/filter_expnese_bloc.dart';
import 'package:my_money_v3/features/home/domain/usecases/get_backup.dart';
import 'package:my_money_v3/features/home/presentation/cubit/home_drawer_cubit.dart';
import 'package:my_money_v3/features/report/data/data_sources/report_data_source.dart';
import 'package:my_money_v3/features/report/data/repository/report_repository_impl.dart';
import 'package:my_money_v3/features/report/domain/repository/report_repository.dart';
import 'package:my_money_v3/features/report/domain/use_cases/get_report_use_case.dart';
import 'package:my_money_v3/features/report/presentation/bloc/report_bloc.dart';
import 'package:my_money_v3/features/settings/data/datasource/settings_data_source.dart';
import 'package:my_money_v3/features/settings/data/repository/settings_repository_impl.dart';
import 'package:my_money_v3/features/settings/domain/repository/settings_repository.dart';
import 'package:my_money_v3/features/settings/domain/usecases/change_lang_use_case.dart';
import 'package:my_money_v3/features/settings/domain/usecases/change_money_unit.dart';
import 'package:my_money_v3/features/settings/domain/usecases/get_saved_lang_use_case.dart';
import 'package:my_money_v3/features/settings/domain/usecases/get_saved_settings_use_case.dart';
import 'package:my_money_v3/features/settings/domain/usecases/save_user_theme_usecase.dart';
import 'package:my_money_v3/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:my_money_v3/features/splash/domain/usecases/initialize_app_use_case.dart';
import 'package:my_money_v3/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/category/data/datasources/category_local_data_source.dart';
import 'features/category/data/repositories/category_repository_impl.dart';
import 'features/category/domain/repositories/category_repository.dart';
import 'features/category/domain/usecases/add_category_use_case.dart';
import 'features/category/domain/usecases/category_list_use_case.dart';
import 'features/category/domain/usecases/delete_category_use_case.dart';
import 'features/category/domain/usecases/get_categories_use_case.dart';
import 'features/category/presentation/cubit/category_cubit.dart';
import 'features/expense/data/datasources/expnese_local_data_source.dart';
import 'features/expense/data/repositories/expense_repository_impl.dart';
import 'features/expense/domain/repositories/expense_repository.dart';
import 'features/expense/domain/usecases/add_edit_expense_use_case.dart';
import 'features/expense/domain/usecases/delete_expense_use_case.dart';
import 'features/expense/domain/usecases/expense_list_use_case.dart';
import 'features/filter_expense/data/repositories/filter_expense_repository_impl.dart';
import 'features/home/data/datasources/home_info_local_data_source.dart';
import 'features/home/data/repositories/home_info_repository_impl.dart';
import 'features/home/domain/repositories/home_info_repository.dart';
import 'features/home/domain/usecases/get_home_info.dart';
import 'features/home/presentation/cubit/home_info_cubit.dart';
import 'features/splash/data/datasources/splash_local_data_source.dart';
import 'features/splash/data/repositories/splash_repository_impl.dart';
import 'features/splash/domain/repositories/splash_repository.dart';
import 'shared/components/components.dart';

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
