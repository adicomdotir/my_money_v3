import 'package:get_it/get_it.dart';
import 'package:my_money_v3/features/expense/presentation/add_edit_expense/cubit/add_edit_expense_cubit.dart';
import 'package:my_money_v3/features/expense/presentation/expense_list/cubit/expense_cubit.dart';
import 'package:my_money_v3/features/report/data/data_sources/report_data_source.dart';
import 'package:my_money_v3/features/report/data/repository/report_repository_impl.dart';
import 'package:my_money_v3/features/report/domain/repository/report_repository.dart';
import 'package:my_money_v3/features/report/domain/use_cases/get_report_use_case.dart';
import 'package:my_money_v3/features/report/presentation/bloc/report_bloc.dart';
import 'package:my_money_v3/features/splash/domain/usecases/get_saved_settings.dart';
import 'package:my_money_v3/features/splash/presentation/bloc/global_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/shared/category_drop_down/presentation/cubit/categories_drop_down_cubit.dart';

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
import 'features/home/data/datasources/home_info_local_data_source.dart';
import 'features/home/data/repositories/home_info_repository_impl.dart';
import 'features/home/domain/repositories/home_info_repository.dart';
import 'features/home/domain/usecases/get_home_info.dart';
import 'features/home/presentation/cubit/home_info_cubit.dart';
import 'features/splash/data/datasources/lang_local_data_source.dart';
import 'features/splash/data/repositories/lang_repository_impl.dart';
import 'features/splash/domain/repositories/lang_repository.dart';
import 'features/splash/domain/usecases/change_lang.dart';
import 'features/splash/domain/usecases/get_saved_lang.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // Blocs
  sl.registerFactory<HomeInfoCubit>(
    () => HomeInfoCubit(getHomeInfoUseCase: sl()),
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
  sl.registerFactory<CategoriesDropDownCubit>(
    () => CategoriesDropDownCubit(
      categoryListUseCase: sl(),
    ),
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

  // Use cases
  sl.registerLazySingleton<GetHomeInfo>(
    () => GetHomeInfo(homeInfoRepository: sl()),
  );
  sl.registerLazySingleton<GetSavedLangUseCase>(
    () => GetSavedLangUseCase(langRepository: sl()),
  );
  sl.registerLazySingleton<ChangeLangUseCase>(
    () => ChangeLangUseCase(langRepository: sl()),
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
    () => GetSavedSettingsUseCase(langRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<HomeInfoRepository>(
    () => HomeInfoRepositoryImpl(
      homeInfoLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<LangRepository>(
    () => LangRepositoryImpl(langLocalDataSource: sl()),
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

  // Data Sources
  sl.registerLazySingleton<HomeInfoLocalDataSource>(
    () => HomeInfoLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<LangLocalDataSource>(
    () => LangLocalDataSourceImpl(sharedPreferences: sl()),
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

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DatabaseHelper());
}
