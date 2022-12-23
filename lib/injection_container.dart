import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/features/add_edit_category/data/datasources/category_local_data_source.dart';
import 'package:my_money_v3/features/add_edit_category/data/repositories/category_repository_impl.dart';
import 'package:my_money_v3/features/add_edit_category/domain/repositories/category_repository.dart';
import 'package:my_money_v3/features/add_edit_category/domain/usecases/add_category_use_case.dart';
import 'package:my_money_v3/features/add_edit_category/presentation/cubit/add_edit_category_cubit.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/datasources/expnese_local_data_source.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/repositories/expense_repository_impl.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/repositories/expense_repository.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/usecases/get_expense_use_case.dart';
import 'package:my_money_v3/features/add_edit_expanse/presentation/cubit/add_edit_expense_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/network/netwok_info.dart';
import 'features/add_edit_expanse/data/datasources/expense_remote_data_source.dart';
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
    () => AddEditExpenseCubit(getExpenseUseCase: sl()),
  );
  sl.registerFactory<AddEditCategoryCubit>(
    () => AddEditCategoryCubit(addCategoryUseCase: sl()),
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
  sl.registerLazySingleton<GetExpenseUseCase>(
    () => GetExpenseUseCase(expenseRepository: sl()),
  );
  sl.registerLazySingleton<AddCategoryUseCase>(
    () => AddCategoryUseCase(categoryRepository: sl()),
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
    () => ExpenseLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(databaseHelper: sl()),
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
