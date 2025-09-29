import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/features/category/domain/usecases/category_list_use_case.dart';
import 'package:my_money_v3/shared/components/category_dropdown/category_dropdown_cubit.dart';
import 'package:my_money_v3/shared/components/category_dropdown/category_dropdown_state.dart';
import 'package:my_money_v3/shared/components/category_dropdown/category_dropdown_widget.dart';
import 'package:my_money_v3/shared/data/models/category_model.dart';

class _FakeCubit extends Cubit<CategoryDropdownState>
    implements CategoryDropdownCubit {
  _FakeCubit() : super(CategoryDropdownLoading());
  @override
  Future<void> getCategories() async {}

  @override
  // TODO: implement categoryListUseCase
  CategoryListUseCase get categoryListUseCase => throw UnimplementedError();
}

void main() {
  testWidgets('Dropdown shows icon images for categories', (tester) async {
    final categories = [
      const CategoryModel(
        id: '1',
        parentId: '',
        title: 'Food',
        color: '#FF0000',
        iconKey: 'ic_food',
      ),
      const CategoryModel(
        id: '2',
        parentId: '',
        title: 'Taxi',
        color: '#00FF00',
        iconKey: 'ic_taxi',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<CategoryDropdownCubit>(
            create: (_) =>
                _FakeCubit()..emit(CategoryDropdownLoaded(categories)),
            child: CategoryDropdownWidget(
              value: '1',
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    // Expand dropdown
    await tester.tap(find.byType(DropdownButton));
    await tester.pumpAndSettle();

    // Expect images inside the dropdown menu items
    expect(find.byType(Image), findsWidgets);
  });
}
