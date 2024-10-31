import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/utils/functions/functions.dart';
import 'package:my_money_v3/features/report/domain/entities/report_entity.dart';
import 'package:my_money_v3/features/splash/presentation/bloc/global_bloc.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../../core/utils/price_format.dart';
import '../bloc/report_bloc.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ReportBloc>(context).add(GetReportEvent());
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        if (state is ReportSuccesState) {
          return Scaffold(
            appBar: AppBar(title: const Text('گزارش')),
            body: ListView.builder(
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          headerCard(state, index, context),
                          if (!state.showPieChart)
                            ...detailCategoryExpenseList(state, index, context),
                          if (!state.showPieChart)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: double.infinity,
                              height: 16,
                              child: CustomPaint(
                                painter: LinearPainter(
                                  state.reports[index].catExpneseList,
                                ),
                              ),
                            ),
                          if (state.showPieChart)
                            PieChart(
                              dataMap: pieChartDataMapper(
                                state.reports[index].catExpneseList,
                              ),
                              chartType: ChartType.disc,
                              legendOptions: const LegendOptions(
                                showLegends: true,
                                legendPosition: LegendPosition.left,
                              ),
                              formatChartValues: (value) =>
                                  '${value.toStringAsFixed(1)} %',
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is ReportErrorState) {
          return Text(state.message);
        } else {
          return const Text('No Data');
        }
      },
    );
  }

  List<Widget> detailCategoryExpenseList(
    ReportSuccesState state,
    int index,
    BuildContext context,
  ) {
    return List.generate(
      state.reports[index].catExpneseList.length,
      (idx) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 0,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getColor(
                  state.reports[index].catExpneseList[idx].color,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.reports[index].catExpneseList[idx].title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF424242),
                  ),
                ),
                Text(
                  '${state.reports[index].catExpneseList[idx].transactionCount} تراکنش',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF616161),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  priceFormat(
                    state.reports[index].catExpneseList[idx].price,
                    context.read<GlobalBloc>().state.settings.unit,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFE53935),
                  ),
                ),
                Text(
                  '${(state.reports[index].catExpneseList[idx].percent).toStringAsFixed(1)} %',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF212121),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row headerCard(ReportSuccesState state, int index, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              _getMonthName(
                state.reports[index].monthName,
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              priceFormat(
                state.reports[index].sumPrice,
                context.read<GlobalBloc>().state.settings.unit,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            context.read<ReportBloc>().add(
                  SwitchTypeCard(!state.showPieChart),
                );
          },
          icon: const Icon(Icons.switch_camera_outlined),
        ),
      ],
    );
  }

  String _getMonthName(String monthName) {
    final dateArray = monthName.split('/');
    final year = dateArray.first;
    final month = int.tryParse(dateArray.last) ?? 1;
    return '${getMonthName(month - 1)} $year';
  }

  Map<String, double> pieChartDataMapper(List<CatExpense> catExpneseList) {
    final result = <String, double>{};
    for (var catExpense in catExpneseList) {
      result[catExpense.title] = catExpense.percent;
    }
    return result;
  }
}

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
        Paint()..color = _getColor(catExpense.color),
      );
      lastWidth += size.width * catExpense.percent / 100;
    }
  }

  @override
  bool shouldRepaint(LinearPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LinearPainter oldDelegate) => false;
}

Color _getColor(String color) {
  if (color.isEmpty) {
    return Colors.black;
  } else {
    color = color.toUpperCase().replaceAll('#', '');
    if (color.length == 6) {
      color = 'FF$color';
    }
    return Color(int.tryParse(color, radix: 16) ?? 0);
  }
}
