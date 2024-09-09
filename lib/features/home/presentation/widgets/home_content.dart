import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/utils/hex_color.dart';
import 'package:my_money_v3/core/utils/price_format.dart';
import 'package:my_money_v3/features/home/domain/entities/home_info_entity.dart';
import 'package:my_money_v3/features/splash/presentation/bloc/global_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../config/routes/app_routes.dart';
import '../cubit/home_info_cubit.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    required this.homeInfoList,
    Key? key,
  }) : super(key: key);

  final HomeInfoEntity homeInfoList;

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24;
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          reportGeneral(height, context),
          reportByCategory(height, context),
        ],
      ),
    );
  }

  Container reportGeneral(double height, BuildContext context) {
    final jalali = Jalali.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height * .3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          reportGeneralItem(
            'هزینه امروز (${jalali.formatShortMonthDay()})',
            homeInfoList.todayPrice,
            context,
          ),
          reportGeneralItem(
            'هزینه ماه (${jalali.formatter.mN})',
            homeInfoList.monthPrice,
            context,
          ),
          reportGeneralItem(
            'هزینه ۳۰ روز گذشته',
            homeInfoList.thirtyDaysPrice,
            context,
          ),
          reportGeneralItem(
            'هزینه ۹۰ روز گذشته',
            homeInfoList.ninetyDaysPrice,
            context,
          ),
        ],
      ),
    );
  }

  Container reportGeneralItem(String title, int price, context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            priceFormat(
              price,
              BlocProvider.of<GlobalBloc>(context).state.settings.unit,
            ),
          ),
        ],
      ),
    );
  }

  Container reportByCategory(double height, BuildContext context) {
    return Container(
      height: height * .7,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'هزینه های این ماه با دسته بندی',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.expenseListRoute).then(
                    (value) =>
                        BlocProvider.of<HomeInfoCubit>(context).getHomeInfo(),
                  );
                },
                child: const Text('مشاهده همه'),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 64),
              itemCount: homeInfoList.expenseByCategory.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 16,
              ),
              itemBuilder: (context, index) {
                final item = homeInfoList.expenseByCategory[index];
                return Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                color: HexColor(
                                  item.color,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(item.title),
                            ],
                          ),
                          Text(
                            priceFormat(
                              item.price,
                              context.read<GlobalBloc>().state.settings.unit,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 2,
                      color: HexColor(item.color),
                    ),
                  ],
                );
              },
            ),
          ),
          // const SizedBox(height: 48),
        ],
      ),
    );
  }
}
