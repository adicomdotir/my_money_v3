import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/utils/price_format.dart';
import 'package:my_money_v3/features/report/domain/entities/report_entity.dart';

import '../bloc/report_bloc.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Report')),
          body: ListView.builder(
            itemCount: report.length,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report[index].monthName),
                    Text(priceFormat(report[index].sumPrice)),
                    ...List.generate(
                      report[index].catExpneseList.length,
                      (idx) => Text(
                        '${report[index].catExpneseList[idx].title} :: ${priceFormat(report[index].catExpneseList[idx].price)}',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

List<ReportEnitty> report = [
  ReportEnitty(
    monthName: 'monthName',
    sumPrice: 30000,
    catExpneseList: [
      CatExpense(title: 'غذا', price: 10000),
      CatExpense(title: 'title', price: 10000),
      CatExpense(title: 'title', price: 10000),
      CatExpense(title: 'title', price: 10000),
      CatExpense(title: 'title', price: 10000),
    ],
  ),
  ReportEnitty(
    monthName: 'monthName2',
    sumPrice: 310000,
    catExpneseList: [
      CatExpense(title: 'title1', price: 10000),
      CatExpense(title: 'title1', price: 10000),
      CatExpense(title: 'tit1le1', price: 10000),
      CatExpense(title: 'tit1le', price: 10000),
      CatExpense(title: 'tit1le', price: 10000),
    ],
  ),
];
