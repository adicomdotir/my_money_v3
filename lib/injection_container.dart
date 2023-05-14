import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/shared/category_drop_down/presentation/cubit/categories_drop_down_cubit.dart';

import 'features/category/data/datasources/category_list_local_data_source.dart';
import 'features/category/data/datasources/category_local_data_source.dart';
import 'features/category/data/repositories/category_list_repository_impl.dart';
import 'features/category/data/repositories/category_repository_impl.dart';
import 'features/category/domain/repositories/category_list_repository.dart';
import 'features/category/domain/repositories/category_repository.dart';
import 'features/category/domain/usecases/add_category_use_case.dart';
import 'features/category/domain/usecases/category_list_use_case.dart';
import 'features/category/domain/usecases/delete_category_use_case.dart';
import 'features/category/domain/usecases/get_categories_use_case.dart';
import 'features/category/presentation/cubit/category_cubit.dart';
import 'features/expense/data/datasources/expense_remote_data_source.dart';
import 'features/expense/data/datasources/expnese_local_data_source.dart';
import 'features/expense/data/repositories/expense_repository_impl.dart';
import 'features/expense/domain/repositories/expense_repository.dart';
import 'features/expense/domain/usecases/add_edit_expense_use_case.dart';
import 'features/expense/domain/usecases/delete_expense_use_case.dart';
import 'features/expense/domain/usecases/expense_list_use_case.dart';
import 'features/expense/presentation/cubit/expense_cubit.dart';
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
import 'features/splash/presentation/cubit/locale_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // Blocs
  sl.registerFactory<HomeInfoCubit>(
    () => HomeInfoCubit(getHomeInfoUseCase: sl()),
  );
  sl.registerFactory<LocaleCubit>(
    () => LocaleCubit(getSavedLangUseCase: sl(), changeLangUseCase: sl()),
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
      addEditExpenseUseCase: sl(),
    ),
  );
  sl.registerFactory<CategoriesDropDownCubit>(
    () => CategoriesDropDownCubit(
      categoryListUseCase: sl(),
    ),
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
    () => CategoryListUseCase(categoryListRepository: sl()),
  );
  sl.registerLazySingleton<DeleteCategoryUseCase>(
    () => DeleteCategoryUseCase(categoryListRepository: sl()),
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
      expenseRemoteDataSource: sl(),
      expenseLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(categoryLocalDataSource: sl()),
  );
  sl.registerLazySingleton<CategoryListRepository>(
    () => CategoryListRepositoryImpl(categoryListLocalDataSource: sl()),
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
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<CategoryListLocalDataSource>(
    () => CategoryListLocalDataSourceImpl(databaseHelper: sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DatabaseHelper());
}
