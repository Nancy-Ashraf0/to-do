import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/ui/providers/theme_provider.dart';

import '../home/home.dart';

class Splash extends StatelessWidget {
  Splash({super.key});

  static const String routeName = "splash";
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of(context);
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, Home.routeName);
      },
    );
    return Scaffold(
      backgroundColor: themeProvider.splashBg,
      body: Center(
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}
