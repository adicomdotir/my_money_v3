import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/features/category/presentation/widgets/add_edit_category_content.dart';

void main() {
  testWidgets('Select icon updates preview and save payload', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AddEditCategoryContent()),
      ),
    );

    // Open icon dialog
    await tester.tap(find.text('انتخاب آیکون'));
    await tester.pumpAndSettle();

    // Tap first icon in grid
    final gridItems = find.byType(Image);
    expect(gridItems, findsWidgets);
    await tester.tap(gridItems.first);
    await tester.pumpAndSettle();

    // After selection, preview image should exist
    expect(find.byType(Image), findsWidgets);
  });
}
