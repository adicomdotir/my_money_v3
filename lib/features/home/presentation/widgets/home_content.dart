import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/home/presentation/widgets/category_expenses_section_header.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../../core/bloc/global_bloc.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../config/routes/app_routes.dart';
import '../../domain/entities/home_info_entity.dart';

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
          _reportGeneralItem(
            'هزینه امروز (${jalali.formatShortMonthDay()})',
            widget.homeInfoList.todayPrice,
            context,
            FontWeight.bold,
            Icons.access_time_filled,
          ),
          _reportGeneralItem(
            'هزینه ماه (${jalali.formatter.mN})',
            widget.homeInfoList.monthPrice,
            context,
            FontWeight.w400,
            Icons.calendar_month,
          ),
          _reportGeneralItem(
            'هزینه ۳۰ روز گذشته',
            widget.homeInfoList.thirtyDaysPrice,
            context,
            FontWeight.w400,
            Icons.bar_chart,
          ),
          _reportGeneralItem(
            'هزینه ۹۰ روز گذشته',
            widget.homeInfoList.ninetyDaysPrice,
            context,
            FontWeight.w400,
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Container _reportGeneralItem(
    String title,
    int price,
    BuildContext context,
    FontWeight fontWeight,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontWeight: fontWeight),
              ),
            ],
          ),
          Text(
            formatPrice(
              price,
              BlocProvider.of<GlobalBloc>(context).state.settings.unit,
            ),
            style: TextStyle(
              fontWeight: fontWeight,
              color: Theme.of(context).primaryColor,
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
          CategoryExpensesSectionHeader(),
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
                        height: 48,
                        child: Row(
                          children: [
                            // جایگزینی آیکون ثابت با رنگ دسته‌بندی
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: HexColor(
                                  item.color,
                                ), // استفاده از رنگ واقعی دسته‌بندی
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Text(
                              '${formatPrice(item.price, context.read<GlobalBloc>().state.settings.unit)} '
                              '(${calculatePercentage(item.price.toDouble()).toStringAsFixed(1)}%)',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: calculatePercentage(
                              item.price.toDouble(),
                            ) /
                            100,
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            AlwaysStoppedAnimation(HexColor(item.color)),
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

  double calculatePercentage(double itemPrice) {
    double total = 0;
    for (var item in widget.homeInfoList.expenseByCategory) {
      total += item.price;
    }
    if (total == 0) {
      return 0;
    }
    return (itemPrice / total) * 100;
  }
}
