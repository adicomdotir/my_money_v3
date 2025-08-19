import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/report/presentation/widgets/linear_painter.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../../../core/bloc/global_bloc.dart';
import '../../../../../core/utils/colors/color_parser.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../config/routes/app_routes.dart';
import '../../utils/report_chart_mapper.dart';
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
                          _buildHeaderCard(state, index, context),
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
                              dataMap: ReportChartMapper.pieChartDataMapper(
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
    final report = state.reports[index];
    return List.generate(
      report.catExpneseList.length,
      (idx) => InkWell(
        onTap: () {
          final id = report.catExpneseList[idx].id;
          final fromDate = report.monthName;
          Navigator.pushNamed(
            context,
            Routes.filterExpenseRoute,
            arguments: {'id': id, 'fromDate': fromDate},
          );
        },
        child: Padding(
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
                  color: report.catExpneseList[idx].color.toColor(),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.catExpneseList[idx].title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF424242),
                    ),
                  ),
                  Text(
                    '${report.catExpneseList[idx].transactionCount} تراکنش',
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
                    formatPrice(
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
                    '${(report.catExpneseList[idx].percent).toStringAsFixed(1)} %',
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
      ),
    );
  }

  Row _buildHeaderCard(
    ReportSuccesState state,
    int index,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              getPersianMonthNameFromString(
                state.reports[index].monthName,
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              formatPrice(
                state.reports[index].sumPrice,
                context.read<GlobalBloc>().state.settings.unit,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            context.read<ReportBloc>().add(
                  SwitchTypeCardEvent(!state.showPieChart),
                );
          },
          icon: const Icon(Icons.switch_camera_outlined),
        ),
      ],
    );
  }
}
