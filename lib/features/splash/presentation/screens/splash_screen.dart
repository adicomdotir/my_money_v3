import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SplashBloc>()..add(const InitializeAppEvent()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            Navigator.pushReplacementNamed(context, Routes.homeRoute);
          } else if (state is SplashError) {
            // Handle error - maybe show a dialog or retry button
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    context.read<SplashBloc>().add(const InitializeAppEvent());
                  },
                ),
              ),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetPaths.logo),
                const SizedBox(height: 20),
                BlocBuilder<SplashBloc, SplashState>(
                  builder: (context, state) {
                    if (state is SplashLoading) {
                      return const CircularProgressIndicator();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
