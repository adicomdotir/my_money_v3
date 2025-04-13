import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/utils/hex_color.dart';
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
                      .read<SettingsBloc>()
                      .add(SaveUserThemeEvent(themeId: model.id));
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
  final int id;
  final String faName;
  final int color;
  final FlexScheme scheme;

  ThemeColorUiModel({
    required this.id,
    required this.color,
    required this.faName,
    required this.scheme,
  });
}

final themes = [
  ThemeColorUiModel(
    id: 1,
    scheme: FlexScheme.redM3,
    faName: 'قرمز',
    color: HexColor.getColorFromHex(Colors.red.hex),
  ),
  ThemeColorUiModel(
    id: 2,
    scheme: FlexScheme.blueM3,
    faName: 'ابی',
    color: HexColor.getColorFromHex(Colors.blue.hex),
  ),
  ThemeColorUiModel(
    id: 3,
    scheme: FlexScheme.cyanM3,
    faName: 'ابی یشمی',
    color: HexColor.getColorFromHex(Colors.cyan.hex),
  ),
  ThemeColorUiModel(
    id: 4,
    scheme: FlexScheme.limeM3,
    faName: 'لیمویی',
    color: HexColor.getColorFromHex(Colors.lime.hex),
  ),
  ThemeColorUiModel(
    id: 5,
    scheme: FlexScheme.pinkM3,
    faName: 'صورتی',
    color: HexColor.getColorFromHex(Colors.pink.hex),
  ),
  ThemeColorUiModel(
    id: 6,
    scheme: FlexScheme.tealM3,
    faName: 'سبزابی',
    color: HexColor.getColorFromHex(Colors.teal.hex),
  ),
  ThemeColorUiModel(
    id: 7,
    scheme: FlexScheme.greenM3,
    faName: 'سبز',
    color: HexColor.getColorFromHex(Colors.green.hex),
  ),
  ThemeColorUiModel(
    id: 8,
    scheme: FlexScheme.indigoM3,
    faName: 'سرمه ای',
    color: HexColor.getColorFromHex(Colors.indigo.hex),
  ),
  ThemeColorUiModel(
    id: 9,
    scheme: FlexScheme.orangeM3,
    faName: 'نارنجی',
    color: HexColor.getColorFromHex(Colors.orange.hex),
  ),
  ThemeColorUiModel(
    id: 10,
    scheme: FlexScheme.purpleM3,
    faName: 'بنفش',
    color: HexColor.getColorFromHex(Colors.purple.hex),
  ),
  ThemeColorUiModel(
    id: 11,
    scheme: FlexScheme.yellowM3,
    faName: 'زرد',
    color: HexColor.getColorFromHex(Colors.yellow.hex),
  ),
  ThemeColorUiModel(
    id: 12,
    scheme: FlexScheme.deepOrangeM3,
    faName: 'نارنجی عمیق',
    color: HexColor.getColorFromHex(Colors.deepOrange.hex),
  ),
];
