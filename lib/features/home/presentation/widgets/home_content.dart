import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../../core/bloc/global_bloc.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../config/routes/app_routes.dart';
import '../../domain/entities/home_info_entity.dart';
import '../cubit/home_info_cubit.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({
    required this.homeInfoList,
    super.key,
  });

  final HomeInfoEntity homeInfoList;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  AnimationController? animation;
  Animation<double>? _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation!);

    // animation?.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animation?.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     animation?.forward();
    //   }
    // });
    animation?.forward();
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24;
    return FadeTransition(
      opacity: _fadeInFadeOut!,
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            reportGeneral(height, context),
            reportByCategory(height, context),
          ],
        ),
      ),
    );
  }

  Widget reportGeneral(double height, BuildContext context) {
    final jalali = Jalali.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height * .3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          reportGeneralItem(
            'هزینه امروز (${jalali.formatShortMonthDay()})',
            widget.homeInfoList.todayPrice,
            context,
          ),
          reportGeneralItem(
            'هزینه ماه (${jalali.formatter.mN})',
            widget.homeInfoList.monthPrice,
            context,
          ),
          reportGeneralItem(
            'هزینه ۳۰ روز گذشته',
            widget.homeInfoList.thirtyDaysPrice,
            context,
          ),
          reportGeneralItem(
            'هزینه ۹۰ روز گذشته',
            widget.homeInfoList.ninetyDaysPrice,
            context,
          ),
        ],
      ),
    );
  }

  Container reportGeneralItem(String title, int price, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            formatPrice(
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
                  Navigator.pushNamed(context, Routes.expenseListRoute)
                      .then((value) {
                    if (context.mounted) {
                      BlocProvider.of<HomeInfoCubit>(context).getHomeInfo();
                    }
                  });
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
              itemCount: widget.homeInfoList.expenseByCategory.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 16,
              ),
              itemBuilder: (context, index) {
                final item = widget.homeInfoList.expenseByCategory[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.filterExpenseRoute,
                      arguments: {'id': item.id},
                    );
                  },
                  child: Column(
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
                              formatPrice(
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
                  ),
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
