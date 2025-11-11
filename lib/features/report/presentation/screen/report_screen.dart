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
        appBar: AppBar(
          title: Text('📊 گزارش مالی'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: _buildReportList(context, state),
      );
    } else if (state is ReportErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              state.message,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (state is ReportLoadingState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'در حال بارگذاری گزارش...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'داده‌ای برای نمایش وجود ندارد',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildReportList(BuildContext context, ReportSuccessState state) {
    return ListView.builder(
      itemCount: state.reports.length,
      itemBuilder: (context, index) {
        final report = state.reports[index];
        return _buildReportCard(context, report, state.showPieChart);
      },
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    ReportEntity report,
    bool showPieChart,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.05),
                Theme.of(context).primaryColor.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(context, report, showPieChart),
                SizedBox(height: 16),
                if (!showPieChart) _buildCategoryList(context, report),
                if (!showPieChart) _buildLinearProgress(report),
                if (showPieChart) _buildPieChart(context, report),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ReportEntity report,
    bool showPieChart,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildReportSummary(context, report),
          ),
          _buildChartToggleButton(context, showPieChart),
        ],
      ),
    );
  }

  Widget _buildReportSummary(BuildContext context, ReportEntity report) {
    final globalBloc = context.read<GlobalBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 8),
            Text(
              getPersianMonthNameFromString(report.monthName),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          formatPrice(report.sumPrice, globalBloc.state.settings.unit),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        SizedBox(height: 8),
        Text(
          '${report.sumPriceUsd.toStringAsFixed(1)} دلار',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
      ],
    );
  }

  Widget _buildChartToggleButton(BuildContext context, bool showPieChart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          context.read<ReportBloc>().add(SwitchTypeCardEvent(!showPieChart));
        },
        icon: Icon(
          showPieChart ? Icons.bar_chart : Icons.pie_chart,
          color: Theme.of(context).primaryColor,
        ),
        tooltip: showPieChart ? 'نمایش نمودار خطی' : 'نمایش نمودار دایره‌ای',
      ),
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
      ),
      child: InkWell(
        onTap: () =>
            _navigateToFilterExpense(context, catExpense.id, monthName),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // دایره رنگی
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: catExpense.color.toColor(),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: catExpense.color.toColor().withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${catExpense.percent.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),

              // اطلاعات دسته
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catExpense.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${catExpense.transactionCount} تراکنش',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // مبلغ
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatPrice(
                      catExpense.price,
                      context.read<GlobalBloc>().state.settings.unit,
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${catExpense.usdPrice.toStringAsFixed(1)} دلار',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${catExpense.percent.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
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

  Widget _buildPieChart(BuildContext context, ReportEntity report) {
    return Container(
      padding: EdgeInsets.all(16),
      child: PieChart(
        dataMap: ReportChartMapper.pieChartDataMapper(report.catExpneseList),
        chartType: ChartType.disc,
        baseChartColor: Theme.of(context).primaryColor,
        colorList:
            report.catExpneseList.map((cat) => cat.color.toColor()).toList(),
        chartRadius: MediaQuery.of(context).size.width / 3,
        legendOptions: LegendOptions(
          showLegends: true,
          legendPosition: LegendPosition.bottom,
          legendTextStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValues: true,
          showChartValuesOutside: true,
          decimalPlaces: 1,
          chartValueStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        formatChartValues: (value) => '${value.toStringAsFixed(1)}%',
      ),
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
