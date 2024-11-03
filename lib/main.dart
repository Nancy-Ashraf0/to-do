import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/ui/providers/lang_provider.dart';
import 'package:to_do_app/ui/providers/list_provider.dart';
import 'package:to_do_app/ui/providers/theme_provider.dart';
import 'package:to_do_app/ui/screens/home/edit/edit.dart';
import 'package:to_do_app/ui/screens/home/home.dart';
import 'package:to_do_app/ui/screens/login/login.dart';
import 'package:to_do_app/ui/screens/register/register.dart';
import 'package:to_do_app/ui/screens/splash/splash.dart';
import 'package:to_do_app/utils/app_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: ChangeNotifierProvider(
          create: (context) => ListProvider(), child: MyApp()),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of(context);
    ThemeProvider themeProvider = Provider.of(context);
    return MaterialApp(
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      routes: {
        Splash.routeName: (_) => Splash(),
        Home.routeName: (_) => Home(),
        Login.routeName: (_) => Login(),
        Register.routeName: (_) => Register(),
        Edit.routeName: (_) => Edit(),
      },
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? Splash.routeName
          : Login.routeName,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      locale: Locale(languageProvider.selectedLang),
    );
  }
}
