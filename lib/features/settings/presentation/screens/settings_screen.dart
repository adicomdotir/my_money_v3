import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:my_money_v3/features/splash/presentation/bloc/global_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool themeSelectShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: themeSelectShow == false
            ? Column(
                children: [
                  const Text(
                    'واحد پولی',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  BlocBuilder<GlobalBloc, GlobalState>(
                    builder: (context, state) {
                      return BlocListener<SettingsBloc, SettingsState>(
                        listener: (context, state) {
                          if (state is SettingsSuccess) {
                            BlocProvider.of<GlobalBloc>(context)
                                .add(GetSettingsGlobalEvent());
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('تومان'),
                                  Radio(
                                    value: 0,
                                    groupValue: state.settings.unit,
                                    onChanged: (value) {
                                      BlocProvider.of<SettingsBloc>(context)
                                          .add(
                                        ChangeMoneyUnitEvent(
                                          settings: state.settings
                                              .copyWith(unit: value),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('ریال'),
                                  Radio(
                                    value: 1,
                                    groupValue: state.settings.unit,
                                    onChanged: (value) {
                                      BlocProvider.of<SettingsBloc>(context)
                                          .add(
                                        ChangeMoneyUnitEvent(
                                          settings: state.settings
                                              .copyWith(unit: value),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        themeSelectShow = true;
                      });
                    },
                    child: Text(
                      'تغییر تصادفی تم',
                    ),
                  ),
                ],
              )
            : _themeSelectBuild(),
      ),
    );
  }

  Widget _themeSelectBuild() {
    return Column(
      children: [
        Text(
          'تم رنگی خود را انتخاب کنید',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: themes.length,
            itemBuilder: (context, index) {
              final model = themes[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(model.color),
                ),
                title: Text(model.faName),
                onTap: () {
                  context
                      .read<GlobalBloc>()
                      .add(ChangeThemeGlobalEvent(scheme: model.scheme));
                  setState(() {
                    themeSelectShow = false;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class ThemeColorUiModel {
  final String faName;
  final int color;
  final FlexScheme scheme;

  ThemeColorUiModel({
    required this.color,
    required this.faName,
    required this.scheme,
  });
}

final themes = [
  ThemeColorUiModel(
    scheme: FlexScheme.redM3,
    faName: 'قرمز',
    color: Colors.red.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.blueM3,
    faName: 'ابی',
    color: Colors.blue.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.cyanM3,
    faName: 'ابی یشمی',
    color: Colors.cyan.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.limeM3,
    faName: 'لیمویی',
    color: Colors.lime.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.pinkM3,
    faName: 'صورتی',
    color: Colors.pink.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.tealM3,
    faName: 'سبزابی',
    color: Colors.teal.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.greenM3,
    faName: 'سبز',
    color: Colors.green.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.indigoM3,
    faName: 'سرمه ای',
    color: Colors.indigo.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.orangeM3,
    faName: 'نارنجی',
    color: Colors.orange.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.purpleM3,
    faName: 'بنفش',
    color: Colors.purple.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.yellowM3,
    faName: 'زرد',
    color: Colors.yellow.value,
  ),
  ThemeColorUiModel(
    scheme: FlexScheme.deepOrangeM3,
    faName: 'نارنجی عمیق',
    color: Colors.deepOrange.value,
  ),
];
