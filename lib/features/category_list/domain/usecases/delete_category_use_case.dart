import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../repositories/category_list_repository.dart';

class DeleteCategoryUseCase implements UseCase<void, DeleteCategoryParams> {
  final CategoryListRepository categoryListRepository;

  DeleteCategoryUseCase({required this.categoryListRepository});

  @override
  Future<Either<Failure, void>> call(DeleteCategoryParams params) =>
      categoryListRepository.deleteCategory(params.id);
}

class DeleteCategoryParams extends Equatable {
  final String id;

  const DeleteCategoryParams(this.id);

  @override
  List<Object?> get props => [id];
}
