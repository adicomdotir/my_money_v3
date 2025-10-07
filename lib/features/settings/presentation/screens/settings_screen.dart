import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/bloc/global_bloc.dart';
import '../../../../../core/utils/utils.dart';
import '../bloc/settings_bloc.dart';

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
        title: Text('⚙️ تنظیمات'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: themeSelectShow == false
              ? _buildMainSettings()
              : _themeSelectBuild(),
        ),
      ),
    );
  }

  Widget _buildMainSettings() {
    return Column(
      children: [
        // کارت واحد پولی
        _buildCurrencyCard(),
        SizedBox(height: 24),

        // کارت تغییر تم
        _buildThemeCard(),
        SizedBox(height: 24),

        // سایر تنظیمات می‌تونن اینجا اضافه بشن
      ],
    );
  }

  Widget _buildCurrencyCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: BlocBuilder<GlobalBloc, GlobalState>(
          builder: (context, state) {
            return BlocListener<SettingsBloc, SettingsState>(
              listener: (context, state) {
                if (state is SettingsSuccess) {
                  BlocProvider.of<GlobalBloc>(context)
                      .add(GetSettingsGlobalEvent());
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.currency_exchange,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'واحد پولی',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCurrencyOption(
                          context: context,
                          value: 0,
                          groupValue: state.settings.unit,
                          label: 'تومان',
                          icon: Icons.attach_money,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildCurrencyOption(
                          context: context,
                          value: 1,
                          groupValue: state.settings.unit,
                          label: 'ریال',
                          icon: Icons.money,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrencyOption({
    required BuildContext context,
    required int value,
    required int groupValue,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<SettingsBloc>(context).add(
          ChangeMoneyUnitEvent(
            settings:
                context.read<GlobalBloc>().state.settings.copyWith(unit: value),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: groupValue == value ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: groupValue == value ? color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: groupValue == value ? color : Colors.grey,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight:
                    groupValue == value ? FontWeight.bold : FontWeight.normal,
                color: groupValue == value ? color : Colors.grey[700],
              ),
            ),
            SizedBox(height: 4),
            if (groupValue == value)
              Icon(Icons.check_circle, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette, color: Theme.of(context).primaryColor),
                SizedBox(width: 12),
                Text(
                  'ظاهر برنامه',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'رنگ و تم برنامه را شخصی‌سازی کنید',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    themeSelectShow = true;
                  });
                },
                icon: Icon(Icons.color_lens),
                label: Text(
                  '🎨 تغییر تم برنامه',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeSelectBuild() {
    return Column(
      children: [
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      themeSelectShow = false;
                    });
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                SizedBox(width: 12),
                Text(
                  '🎨 انتخاب تم برنامه',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: themes.length,
            itemBuilder: (context, index) {
              final model = themes[index];
              return _buildThemeCardItem(model);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCardItem(ThemeColorUiModel model) {
    return GestureDetector(
      onTap: () {
        context.read<SettingsBloc>().add(SaveUserThemeEvent(themeId: model.id));
        context
            .read<GlobalBloc>()
            .add(ChangeThemeGlobalEvent(scheme: model.scheme));
        setState(() {
          themeSelectShow = false;
        });
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(model.color),
                Color(model.color).withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.palette,
                        color: Color(model.color),
                        size: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      model.faName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
