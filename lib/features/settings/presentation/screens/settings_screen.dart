import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/splash/presentation/bloc/global_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                return Row(
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
                              BlocProvider.of<GlobalBloc>(context)
                                  .add(ModifyUnitGlobalEvent(value ?? 0));
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
                              BlocProvider.of<GlobalBloc>(context)
                                  .add(ModifyUnitGlobalEvent(value ?? 0));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
