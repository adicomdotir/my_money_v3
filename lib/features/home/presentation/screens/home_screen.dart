import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/lib.dart';

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
          return AppErrorWidget(
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
              await showDialog<void>(
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // هدر Drawer
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).viewPadding.top,
                        ),
                        // لوگو
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '💰 پول من',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'مدیریت هوشمند هزینه‌ها',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // منوی آیتم‌ها
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          // آیتم‌های منو
                          _buildDrawerItem(
                            context,
                            icon: Icons.receipt_long,
                            title: '📋 هزینه‌ها',
                            subtitle: 'مدیریت هزینه‌های روزانه',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.expenseListRoute,
                              ).then((value) => _getHomeInfo());
                            },
                          ),

                          _buildDrawerItem(
                            context,
                            icon: Icons.category,
                            title: '📂 دسته‌بندی‌ها',
                            subtitle: 'سازماندهی دسته‌ها',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.categoryListRoute,
                              ).then((value) => _getHomeInfo());
                            },
                          ),

                          _buildDrawerItem(
                            context,
                            icon: Icons.bar_chart,
                            title: '📊 گزارش‌ها',
                            subtitle: 'تحلیل و آمار هزینه‌ها',
                            onTap: () {
                              Navigator.pushNamed(context, Routes.reportRoute)
                                  .then((value) => _getHomeInfo());
                            },
                          ),

                          _buildDrawerItem(
                            context,
                            icon: Icons.settings,
                            title: '⚙️ تنظیمات',
                            subtitle: 'شخصی‌سازی برنامه',
                            onTap: () {
                              Navigator.pushNamed(context, Routes.settingsRoute)
                                  .then((value) => _getHomeInfo());
                            },
                          ),

                          _buildDrawerItem(
                            context,
                            icon: Icons.backup,
                            title: '💾 گرفتن پشتیبان',
                            subtitle: 'ذخیره اطلاعات',
                            onTap: () {
                              context.read<HomeDrawerCubit>().getBackup();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // فوتر - نسخه
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'نسخه',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '1.1.5+28',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // آیکون
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),

                // متن
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // فلش
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog<void>(
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
    showDialog<void>(
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
