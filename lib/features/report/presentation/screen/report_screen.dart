import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

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
                          Text(
                            '${_getMonthName(state.reports[index].monthName)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            priceFormat(state.reports[index].sumPrice),
                          ),
                          ...List.generate(
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
                                        state.reports[index].catExpneseList[idx]
                                            .color,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          state.reports[index]
                                              .catExpneseList[idx].price,
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

  _getColor(String color) {
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

  _getMonthName(String monthName) {
    final dateArray = monthName.split('/');
    final year = dateArray.first;
    final month = int.tryParse(dateArray.last) ?? 1;
    return '${JalaliDate.months[month - 1]} $year';
  }
}
