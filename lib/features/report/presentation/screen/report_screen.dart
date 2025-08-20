import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/report/domain/entities/report_entity.dart';
import 'package:my_money_v3/features/report/presentation/widgets/linear_painter.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../../../core/bloc/global_bloc.dart';
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
        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, ReportState state) {
    if (state is ReportSuccessState) {
      return Scaffold(
        appBar: AppBar(title: const Text('گزارش')),
        body: _buildReportList(context, state),
      );
    } else if (state is ReportErrorState) {
      return Center(child: Text(state.message));
    } else if (state is ReportLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return const Center(child: Text('داده‌ای وجود ندارد'));
    }
  }

  Widget _buildReportList(BuildContext context, ReportSuccessState state) {
    return ListView.builder(
      itemCount: state.reports.length,
      itemBuilder: (context, index) {
        final report = state.reports[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildReportCard(context, report, state.showPieChart),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    ReportEntity report,
    bool showPieChart,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeaderCard(context, report, showPieChart),
        if (!showPieChart) _buildCategoryList(context, report),
        if (!showPieChart) _buildLinearProgress(report),
        if (showPieChart) _buildPieChart(report),
      ],
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ReportEntity report,
    bool showPieChart,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildReportSummary(context, report),
        _buildChartToggleButton(context, showPieChart),
      ],
    );
  }

  Widget _buildReportSummary(BuildContext context, ReportEntity report) {
    final globalBloc = context.read<GlobalBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getPersianMonthNameFromString(report.monthName),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatPrice(report.sumPrice, globalBloc.state.settings.unit),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildChartToggleButton(BuildContext context, bool showPieChart) {
    return IconButton(
      onPressed: () {
        context.read<ReportBloc>().add(SwitchTypeCardEvent(!showPieChart));
      },
      icon: Icon(showPieChart ? Icons.bar_chart : Icons.pie_chart),
      tooltip: showPieChart ? 'نمایش نمودار خطی' : 'نمایش نمودار دایره‌ای',
    );
  }

  Widget _buildCategoryList(BuildContext context, ReportEntity report) {
    return Column(
      children: report.catExpneseList
          .map(
            (catExpense) => _buildCategoryItem(
              context,
              catExpense,
              report.monthName,
            ),
          )
          .toList(),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    CatExpense catExpense,
    String monthName,
  ) {
    return InkWell(
      onTap: () => _navigateToFilterExpense(context, catExpense.id, monthName),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            _buildCategoryColorIndicator(catExpense),
            const SizedBox(width: 12),
            _buildCategoryInfo(catExpense),
            const Spacer(),
            _buildCategoryAmounts(context, catExpense),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryColorIndicator(CatExpense catExpense) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: catExpense.color.toColor(),
      ),
    );
  }

  Widget _buildCategoryInfo(CatExpense catExpense) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          catExpense.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF424242),
          ),
        ),
        Text(
          '${catExpense.transactionCount} تراکنش',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF616161),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryAmounts(BuildContext context, CatExpense catExpense) {
    final globalBloc = context.read<GlobalBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatPrice(catExpense.price, globalBloc.state.settings.unit),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFE53935),
          ),
        ),
        Text(
          '${catExpense.percent.toStringAsFixed(1)} %',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF212121),
          ),
        ),
      ],
    );
  }

  Widget _buildLinearProgress(ReportEntity report) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: double.infinity,
      height: 16,
      child: CustomPaint(
        painter: LinearPainter(report.catExpneseList),
      ),
    );
  }

  Widget _buildPieChart(ReportEntity report) {
    return PieChart(
      dataMap: ReportChartMapper.pieChartDataMapper(report.catExpneseList),
      chartType: ChartType.disc,
      legendOptions: const LegendOptions(
        showLegends: true,
        legendPosition: LegendPosition.left,
      ),
      formatChartValues: (value) => '${value.toStringAsFixed(1)} %',
    );
  }

  void _navigateToFilterExpense(
    BuildContext context,
    String id,
    String monthName,
  ) {
    Navigator.pushNamed(
      context,
      Routes.filterExpenseRoute,
      arguments: {'id': id, 'fromDate': monthName},
    );
  }
}
