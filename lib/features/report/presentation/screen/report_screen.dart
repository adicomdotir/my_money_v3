import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/utils/price_format.dart';

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
            appBar: AppBar(title: const Text('Report')),
            body: ListView.builder(
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(state.reports[index].monthName),
                      Text(
                        priceFormat(state.reports[index].sumPrice),
                      ),
                      ...List.generate(
                        state.reports[index].catExpneseList.length,
                        (idx) => Text(
                          '${state.reports[index].catExpneseList[idx].title} :: ${priceFormat(state.reports[index].catExpneseList[idx].price)}',
                        ),
                      ),
                    ],
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
}
