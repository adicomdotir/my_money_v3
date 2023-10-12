import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        (idx) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.reports[index].catExpneseList[idx]
                                        .title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF424242),
                                    ),
                                  ),
                                  const Text(
                                    '36 تراکنش',
                                    style: TextStyle(
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
                                      state.reports[index].catExpneseList[idx]
                                          .price,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFE53935),
                                    ),
                                  ),
                                  const Text(
                                    '32%',
                                    style: TextStyle(
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
