import 'package:my_money_v3/config/routes/app_routes.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/locale/app_localizations.dart';
import '../cubit/home_info_cubit.dart';
import '../widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  _getHomeInfo() => BlocProvider.of<HomeInfoCubit>(context).getHomeInfo();

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
      title: Text(AppLocalizations.of(context)!.translate('app_name')!),
    );
    return RefreshIndicator(
      child: Scaffold(
        key: _key,
        appBar: appBar,
        drawer: Drawer(
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.expenseListRoute)
                      .then((value) => _getHomeInfo());
                },
                child: ListTile(
                  trailing: const Icon(Icons.arrow_forward_outlined),
                  title: Text(
                    AppLocalizations.of(context)!.translate('expenses')!,
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!
                        .translate('expense_description')!,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.categoryListRoute)
                      .then((value) => _getHomeInfo());
                },
                child: ListTile(
                  trailing: const Icon(Icons.arrow_forward_outlined),
                  title: Text(
                    AppLocalizations.of(context)!.translate('categories')!,
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!
                        .translate('category_description')!,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.reportRoute)
                      .then((value) => _getHomeInfo());
                },
                child: const ListTile(
                  trailing: Icon(Icons.arrow_forward_outlined),
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
                  trailing: Icon(Icons.arrow_forward_outlined),
                  title: Text('تنظیمات'),
                  subtitle: Text('تنظیمات'),
                ),
              ),
            ],
          ),
        ),
        body: _buildBodyContent(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, Routes.addEditExpanseRoute)
                .then((value) => _getHomeInfo());
          },
          label: Text(AppLocalizations.of(context)!.translate('add_expense')!),
          icon: const Icon(Icons.add),
        ),
      ),
      onRefresh: () => _getHomeInfo(),
    );
  }
}
