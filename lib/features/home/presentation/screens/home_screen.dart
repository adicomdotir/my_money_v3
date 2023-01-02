import 'package:my_money_v3/config/routes/app_routes.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../splash/presentation/cubit/locale_cubit.dart';
import '../cubit/random_quote_cubit.dart';
import '../widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  _getRandomQuote() =>
      BlocProvider.of<RandomQuoteCubit>(context).getRandomQuote();

  @override
  void initState() {
    super.initState();
    _getRandomQuote();
  }

  Widget _buildBodyContent() {
    return BlocBuilder<RandomQuoteCubit, RandomQuoteState>(
      builder: ((context, state) {
        if (state is RandomQuoteIsLoading) {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.primary,
            ),
          );
        } else if (state is RandomQuoteError) {
          return error_widget.ErrorWidget(
            onPress: () => _getRandomQuote(),
          );
        } else if (state is RandomQuoteLoaded) {
          return Column(
            children: [
              HomeContent(
                quote: state.quote,
              ),
              InkWell(
                onTap: () => _getRandomQuote(),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.primary,
            ),
          );
        }
      }),
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
                  Navigator.pushNamed(context, Routes.expenseListRoute);
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
                onTap: () {},
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
            ],
          ),
        ),
        body: _buildBodyContent(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, Routes.addEditExpanseRoute);
          },
          label: Text(AppLocalizations.of(context)!.translate('add_expense')!),
          icon: const Icon(Icons.add),
        ),
      ),
      onRefresh: () => _getRandomQuote(),
    );
  }
}
