import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/config/routes/app_routes.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:my_money_v3/features/home/presentation/cubit/home_drawer_cubit.dart';

import '../cubit/home_info_cubit.dart';
import '../widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Future<void> _getHomeInfo() =>
      BlocProvider.of<HomeInfoCubit>(context).getHomeInfo();

  @override
  void initState() {
    super.initState();
    _getHomeInfo();
  }

  Widget _buildBodyContent() {
    return BlocBuilder<HomeInfoCubit, HomeInfoState>(
      builder: (context, state) {
        if (state is HomeInfoIsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeInfoError) {
          return error_widget.ErrorWidget(
            onPress: () => _getHomeInfo(),
          );
        } else if (state is HomeInfoLoaded) {
          return Column(
            children: [
              HomeContent(
                homeInfoList: state.homeInfoEntity,
              ),
            ],
          );
        } else {
          return const Center(
            child: Text(
              'color: AppColors.primary',
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
        ),
        onPressed: () {
          _key.currentState!.openDrawer();
        },
      ),
      title: Text('پول من'),
    );
    return RefreshIndicator(
      child: Scaffold(
        key: _key,
        appBar: appBar,
        drawer: BlocListener<HomeDrawerCubit, HomeDrawerState>(
          listener: (context, state) async {
            if (state.loading) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Center(child: CircularProgressIndicator());
                },
              );
            } else if (state.completed || state.error != null) {
              Navigator.of(context, rootNavigator: true).pop();
              if (state.completed) {
                _showSuccessDialog(context);
              } else if (state.error != null) {
                _showErrorDialog(context);
              }
            }
          },
          child: Drawer(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                Container(
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'پول من',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.expenseListRoute)
                              .then((value) => _getHomeInfo());
                        },
                        child: ListTile(
                          trailing: const Icon(Icons.arrow_forward_ios),
                          title: Text(
                            'هزینه ها',
                          ),
                          subtitle: Text(
                            'هزینه ها',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.categoryListRoute)
                              .then((value) => _getHomeInfo());
                        },
                        child: ListTile(
                          trailing: const Icon(Icons.arrow_forward_ios),
                          title: Text(
                            'دسته ها',
                          ),
                          subtitle: Text(
                            'دسته ها',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.reportRoute)
                              .then((value) => _getHomeInfo());
                        },
                        child: const ListTile(
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text('گزارش'),
                          subtitle: Text('گزارش'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.settingsRoute)
                              .then((value) => _getHomeInfo());
                        },
                        child: const ListTile(
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text('تنظیمات'),
                          subtitle: Text('تنظیمات'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          context.read<HomeDrawerCubit>().getBackup();
                        },
                        child: const ListTile(
                          trailing: Icon(Icons.backup_outlined),
                          title: Text('گرفتن بکاپ'),
                          subtitle: Text('گرفتن بکاپ'),
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ورژن',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            '1.0.4+18',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _buildBodyContent(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, Routes.addEditExpanseRoute)
                .then((value) => _getHomeInfo());
          },
          label: Text('اضافه کردن هزینه'),
          icon: const Icon(Icons.add),
        ),
      ),
      onRefresh: () => _getHomeInfo(),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('موفقیت'),
          content: Text('بکاپ با موفقیت گرفته شد.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('باشه'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطا'),
          content: Text('مشکلی در گرفتن بکاپ به وجود آمده است.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('باشه'),
            ),
          ],
        );
      },
    );
  }
}
