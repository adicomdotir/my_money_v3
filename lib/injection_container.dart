import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/features/add_edit_category/data/datasources/category_local_data_source.dart';
import 'package:my_money_v3/features/add_edit_category/data/repositories/category_repository_impl.dart';
import 'package:my_money_v3/features/add_edit_category/domain/repositories/category_repository.dart';
import 'package:my_money_v3/features/add_edit_category/domain/usecases/add_category_use_case.dart';
import 'package:my_money_v3/features/add_edit_category/domain/usecases/get_categories_use_case.dart';
import 'package:my_money_v3/features/add_edit_category/presentation/cubit/add_edit_category_cubit.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/datasources/expnese_local_data_source.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/repositories/expense_repository_impl.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/repositories/expense_repository.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/usecases/add_edit_expense_use_case.dart';
import 'package:my_money_v3/features/add_edit_expanse/presentation/cubit/add_edit_expense_cubit.dart';
import 'package:my_money_v3/features/category_list/domain/repositories/category_list_repository.dart';
import 'package:my_money_v3/features/expanse_list/data/datasources/expnese_list_local_data_source.dart';
import 'package:my_money_v3/features/expanse_list/data/repositories/expense_list_repository_impl.dart';
import 'package:my_money_v3/features/expanse_list/domain/repositories/expense_list_repository.dart';
import 'package:my_money_v3/features/expanse_list/domain/usecases/delete_expense_use_case.dart';
import 'package:my_money_v3/features/expanse_list/domain/usecases/expense_list_use_case.dart';
import 'package:my_money_v3/features/expanse_list/presentation/cubit/expense_list_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/network/netwok_info.dart';
import 'features/add_edit_expanse/data/datasources/expense_remote_data_source.dart';
import 'features/category_list/data/datasources/category_list_local_data_source.dart';
import 'features/category_list/data/repositories/category_list_repository_impl.dart';
import 'features/category_list/domain/usecases/category_list_use_case.dart';
import 'features/category_list/domain/usecases/delete_category_use_case.dart';
import 'features/category_list/presentation/cubit/category_list_cubit.dart';
import 'features/home/data/datasources/random_quote_local_data_source.dart';
import 'features/home/data/datasources/random_quote_remote_data_source.dart';
import 'features/home/data/repositories/quote_repository_impl.dart';
import 'features/home/domain/repositories/quote_repository.dart';
import 'features/home/domain/usecases/get_random_quote.dart';
import 'features/home/presentation/cubit/random_quote_cubit.dart';
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
  sl.registerFactory<RandomQuoteCubit>(
    () => RandomQuoteCubit(getRandomQuoteUseCase: sl()),
  );
  sl.registerFactory<LocaleCubit>(
    () => LocaleCubit(getSavedLangUseCase: sl(), changeLangUseCase: sl()),
  );
  sl.registerFactory<AddEditExpenseCubit>(
    () => AddEditExpenseCubit(
      addEditExpenseUseCase: sl(),
      getCategoriesUseCase: sl(),
    ),
  );
  sl.registerFactory<AddEditCategoryCubit>(
    () => AddEditCategoryCubit(
      addCategoryUseCase: sl(),
      getCategoriesUseCase: sl(),
    ),
  );
  sl.registerFactory<ExpenseListCubit>(
    () => ExpenseListCubit(
      expenseListUseCase: sl(),
      deleteExpenseUseCase: sl(),
    ),
  );
  sl.registerFactory<CategoryListCubit>(
    () => CategoryListCubit(
      categoryListUseCase: sl(),
      deleteCategoryUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetRandomQuote>(
    () => GetRandomQuote(quoteRepository: sl()),
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
    () => ExpenseListUseCase(expenseListRepository: sl()),
  );
  sl.registerLazySingleton<DeleteExpenseUseCase>(
    () => DeleteExpenseUseCase(expenseListRepository: sl()),
  );
  sl.registerLazySingleton<CategoryListUseCase>(
    () => CategoryListUseCase(categoryListRepository: sl()),
  );
  sl.registerLazySingleton<DeleteCategoryUseCase>(
    () => DeleteCategoryUseCase(categoryListRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(
      networkInfo: sl(),
      randomQuoteRemoteDataSource: sl(),
      randomQuoteLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<LangRepository>(
    () => LangRepositoryImpl(langLocalDataSource: sl()),
  );
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
      networkInfo: sl(),
      expenseRemoteDataSource: sl(),
      expenseLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(categoryLocalDataSource: sl()),
  );
  sl.registerLazySingleton<ExpenseListRepository>(
    () => ExpenseListRepositoryImpl(expenseListLocalDataSource: sl()),
  );
  sl.registerLazySingleton<CategoryListRepository>(
    () => CategoryListRepositoryImpl(categoryListLocalDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<RandomQuoteLocalDataSource>(
    () => RandomQuoteLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<RandomQuoteRemoteDataSource>(
    () => RandomQuoteRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<LangLocalDataSource>(
    () => LangLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<ExpenseListLocalDataSource>(
    () => ExpenseListLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<CategoryListLocalDataSource>(
    () => CategoryListLocalDataSourceImpl(databaseHelper: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AppIntercepters());
  sl.registerLazySingleton(
    () => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true,
    ),
  );
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DatabaseHelper());
}
