// This file shows how to integrate the template feature into your app
// Copy these snippets to the appropriate files

// 1. In injection_container.dart, add these to the appropriate methods:

/*
// In _initDataSourceDependencies()
sl.registerLazySingleton<TemplateLocalDataSource>(
  () => TemplateLocalDataSourceImpl(),
);

// In _initRepositoryDependencies()
sl.registerLazySingleton<TemplateRepository>(
  () => TemplateRepositoryImpl(localDataSource: sl()),
);

// In _initUseCaseDependencies()
sl.registerLazySingleton<GetTemplateItemsUseCase>(
  () => GetTemplateItemsUseCase(repository: sl()),
);

sl.registerLazySingleton<CreateTemplateItemUseCase>(
  () => CreateTemplateItemUseCase(repository: sl()),
);

// In _initBlocDependencies()
sl.registerFactory<TemplateBloc>(
  () => TemplateBloc(
    getTemplateItemsUseCase: sl(),
    createTemplateItemUseCase: sl(),
  ),
);

sl.registerFactory<TemplateSimpleCubit>(
  () => TemplateSimpleCubit(repository: sl()),
);
*/

// 2. In app_routes.dart, add:

/*
// In the Routes class:
static const String templateRoute = '/template_route';

// In the switch statement of onGenerateRoute:
case Routes.templateRoute:
  return MaterialPageRoute(
    builder: (context) {
      return BlocProvider(
        create: (context) => di.sl<TemplateBloc>(),
        child: const TemplateListScreen(),
      );
    },
  );
*/

// 3. In main.dart, register Hive adapters:

/*
// Add this before Hive.openBox calls:
Hive.registerAdapter(TemplateModelAdapter());
*/

// 4. Navigation example from another screen:

/*
// Navigate to template feature
Navigator.pushNamed(context, Routes.templateRoute);

// Navigate with arguments
Navigator.pushNamed(
  context, 
  Routes.templateRoute,
  arguments: {'filter': 'active'},
);
*/

// 5. Using in a global provider (if needed):

/*
// In app.dart _blocProviders:
BlocProvider(
  create: (context) => di.sl<TemplateBloc>()
    ..add(const LoadTemplateItemsEvent()),
),
*/

// 6. Example of using the feature in another feature:

/*
// In another feature's use case:
class SomeOtherUseCase {
  final TemplateRepository templateRepository;
  
  SomeOtherUseCase({required this.templateRepository});
  
  Future<Either<Failure, List<TemplateEntity>>> execute() async {
    // Use template repository methods
    return await templateRepository.getTemplateItems();
  }
}
*/
