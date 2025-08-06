# Template Feature - Clean Architecture Example

This is a template feature that demonstrates how to implement a new feature following Clean Architecture principles in Flutter.

## Directory Structure

```
template_feature/
├── data/                       # Data Layer
│   ├── datasources/           # Data sources (local/remote)
│   ├── models/               # Data models (DTOs)
│   └── repositories/         # Repository implementations
├── domain/                    # Domain Layer (Business Logic)
│   ├── entities/             # Business entities
│   ├── repositories/         # Repository interfaces
│   └── usecases/            # Use cases (business rules)
└── presentation/             # Presentation Layer
    ├── bloc/                # BLoC pattern (complex state)
    ├── cubit/              # Cubit pattern (simple state)
    ├── screens/            # UI screens
    └── widgets/            # Reusable widgets
```

## How to Use This Template

### 1. Copy and Rename
```bash
cp -r lib/features/template_feature lib/features/your_feature_name
```

### 2. Update All References
Replace all occurrences of:
- `template_feature` → `your_feature_name`
- `TemplateEntity` → `YourEntity`
- `TemplateModel` → `YourModel`
- `TemplateRepository` → `YourRepository`
- `TemplateBloc` → `YourBloc`
- etc.

### 3. Update Dependency Injection

Add your feature dependencies to `injection_container.dart`:

```dart
// Data Sources
sl.registerLazySingleton<YourLocalDataSource>(
  () => YourLocalDataSourceImpl(),
);

// Repository
sl.registerLazySingleton<YourRepository>(
  () => YourRepositoryImpl(localDataSource: sl()),
);

// Use Cases
sl.registerLazySingleton<GetYourItemsUseCase>(
  () => GetYourItemsUseCase(repository: sl()),
);

// BLoC/Cubit
sl.registerFactory<YourBloc>(
  () => YourBloc(getItemsUseCase: sl()),
);
```

### 4. Update Routes

Add your routes to `app_routes.dart`:

```dart
case Routes.yourFeatureRoute:
  return MaterialPageRoute(
    builder: (context) {
      return BlocProvider(
        create: (context) => di.sl<YourBloc>(),
        child: const YourScreen(),
      );
    },
  );
```

### 5. Update Hive Models

If using Hive, generate the adapter:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Key Patterns Demonstrated

### 1. Clean Architecture Layers

- **Domain Layer**: Contains business logic, entities, and repository interfaces
- **Data Layer**: Implements repositories, manages data sources and models
- **Presentation Layer**: Handles UI and state management

### 2. Error Handling

All repository methods return `Either<Failure, Success>`:

```dart
Future<Either<Failure, List<Entity>>> getItems() async {
  try {
    final result = await dataSource.getItems();
    return Right(result);
  } catch (e) {
    return Left(DatabaseFailure('Error message'));
  }
}
```

### 3. State Management

**Use BLoC for:**
- Complex event flows
- Event transformation
- Debouncing/throttling
- Multiple concurrent operations

**Use Cubit for:**
- Simple CRUD operations
- Direct method calls
- Straightforward state updates

### 4. Use Cases

Each use case represents a single business rule:

```dart
class CreateItemUseCase extends UseCaseWithParam<Entity, Params> {
  @override
  Future<Either<Failure, Entity>> call(Params params) async {
    // Validate business rules
    if (params.title.isEmpty) {
      return Left(ValidationFailure('Title required'));
    }
    
    // Execute operation
    return await repository.createItem(params);
  }
}
```

## Best Practices

1. **Keep layers independent**: Domain layer should not depend on Data or Presentation layers
2. **Use dependency injection**: All dependencies should be injected, not created
3. **Handle errors properly**: Always use try-catch and return meaningful errors
4. **Write testable code**: Use interfaces and dependency injection for easy mocking
5. **Follow single responsibility**: Each class should have one reason to change

## Testing Structure

Create corresponding test files:

```
test/features/your_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── usecases/
└── presentation/
    ├── bloc/
    └── widgets/
```

## Common Modifications

### Adding Remote Data Source

```dart
abstract class YourRemoteDataSource {
  Future<List<YourModel>> getItems();
  Future<YourModel> createItem(YourModel item);
}

class YourRemoteDataSourceImpl implements YourRemoteDataSource {
  final http.Client client;
  
  YourRemoteDataSourceImpl({required this.client});
  
  @override
  Future<List<YourModel>> getItems() async {
    final response = await client.get(Uri.parse('your_api_endpoint'));
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => YourModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
}
```

### Adding Caching

```dart
class YourRepositoryImpl implements YourRepository {
  final YourRemoteDataSource remoteDataSource;
  final YourLocalDataSource localDataSource;
  
  @override
  Future<Either<Failure, List<Entity>>> getItems() async {
    try {
      // Try to get from remote
      final remoteItems = await remoteDataSource.getItems();
      
      // Cache locally
      await localDataSource.cacheItems(remoteItems);
      
      return Right(remoteItems.map((m) => m.toEntity()).toList());
    } on ServerException {
      try {
        // Fallback to cache
        final localItems = await localDataSource.getItems();
        return Right(localItems.map((m) => m.toEntity()).toList());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
```

## Troubleshooting

1. **Hive TypeId conflicts**: Make sure each model has a unique typeId
2. **Dependency injection errors**: Ensure all dependencies are registered in order
3. **State not updating**: Check if you're using the correct `buildWhen` conditions
4. **Navigation issues**: Verify routes are properly registered

## Next Steps

1. Delete this README after creating your feature
2. Implement your specific business logic
3. Add appropriate tests
4. Update the main app documentation