import 'package:flutter/material.dart';
import 'package:my_money_v3/core/utils/hex_color.dart';
import 'package:my_money_v3/core/utils/price_format.dart';
import 'package:my_money_v3/features/home/domain/entities/home_info_entity.dart';

import '../../../../core/utils/app_colors.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    Key? key,
    required this.homeInfoList,
  }) : super(key: key);

  final HomeInfoEntity homeInfoList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'هزینه های این ماه با دسته بندی',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            color: Colors.blueGrey.shade100,
            child: ListView.separated(
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
                            '${priceFormat(item.price)} تومان',
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
        ],
      ),
    );
  }
}
