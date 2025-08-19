import 'package:flutter/material.dart';
import 'package:my_money_v3/core/utils/colors/color_parser.dart';
import 'package:my_money_v3/features/report/domain/entities/report_entity.dart';

class LinearPainter extends CustomPainter {
  final List<CatExpense> catExpenseList;

  LinearPainter(this.catExpenseList);

  @override
  void paint(Canvas canvas, Size size) {
    double lastWidth = 0;
    for (var catExpense in catExpenseList) {
      canvas.drawRect(
        Rect.fromLTWH(
          lastWidth,
          0,
          size.width * catExpense.percent / 100,
          size.height,
        ),
        Paint()..color = catExpense.color.toColor(),
      );
      lastWidth += size.width * catExpense.percent / 100;
    }
  }

  @override
  bool shouldRepaint(LinearPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LinearPainter oldDelegate) => false;
}
