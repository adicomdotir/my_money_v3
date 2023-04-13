import 'package:flutter/material.dart';
import 'package:my_money_v3/core/utils/hex_color.dart';
import 'package:my_money_v3/core/utils/price_format.dart';
import 'package:my_money_v3/features/home/domain/entities/home_info_entity.dart';

import '../../../../core/utils/app_colors.dart';

class HomeContent extends StatelessWidget {
  HomeContent({Key? key}) : super(key: key);

  final HomeInfoEntity homeInfoList = HomeInfoEntity(expenseByCategory: []);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.maxFinite,
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
          Expanded(
            child: ListView.builder(
              itemCount: homeInfoList.length,
              itemBuilder: (context, index) {
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
                                color: HexColor(homeInfoList[index].color),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(homeInfoList[index].title),
                            ],
                          ),
                          Text(
                            '${priceFormat(homeInfoList[index].price)} تومان',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 2,
                      color: HexColor(homeInfoList[index].color),
                    ),
                    const SizedBox(
                      height: 16,
                    )
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
