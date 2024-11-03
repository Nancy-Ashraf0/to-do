import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/ui/providers/lang_provider.dart';
import 'package:to_do_app/ui/providers/theme_provider.dart';
import 'package:to_do_app/utils/app_colors.dart';
import 'package:to_do_app/utils/extensions.dart';

import '../../../login/login.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late LanguageProvider languageProvider;

  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    languageProvider = Provider.of(context);
    themeProvider = Provider.of(context);
    return Column(
      children: [
        Expanded(
          flex: 18,
          child: Container(
            color: AppColors.primary,
          ),
        ),
        Expanded(
          flex: 82,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.localization.language,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  height: 18,
                ),
                buildLangDropdownButton(),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  context.localization.mode,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  height: 18,
                ),
                buildThemeDropdownButton(),
                const SizedBox(
                  height: 30,
                ),
                buildSignOutInkWell(context)
              ],
            ),
          ),
        )
      ],
    );
  }

  InkWell buildSignOutInkWell(BuildContext context) {
    return InkWell(
      onTap: () {
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, Login.routeName);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(context.localization.signOut,
              style: const TextStyle(color: AppColors.primary, fontSize: 18)),
          const Icon(
            Icons.arrow_forward,
            color: AppColors.primary,
          )
        ],
      ),
    );
  }

  buildLangDropdownButton() {
    return DropdownButtonFormField(
      dropdownColor: themeProvider.dropDownColor,
      iconEnabledColor: AppColors.primary,
      isExpanded: true,
      value: languageProvider.selectedLang,
      items: [
        DropdownMenuItem(
            value: "en",
            child: Text(
              "English",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.primary),
            )),
        DropdownMenuItem(
            value: "ar",
            child: Text("العربية",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: AppColors.primary))),
      ],
      onChanged: (newLang) {
        //languageProvider.changeLang;
        languageProvider.setLangPref(newLang!);
      },
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2))),
    );
  }

  buildThemeDropdownButton() {
    return DropdownButtonFormField(
      dropdownColor: themeProvider.dropDownColor,
      iconEnabledColor: AppColors.primary,
      isExpanded: true,
      value: themeProvider.isDarkMode ? "dark" : "light",
      items: [
        DropdownMenuItem(
            value: "light",
            child: Text(context.localization.light,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: AppColors.primary))),
        DropdownMenuItem(
            value: "dark",
            child: Text(context.localization.dark,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: AppColors.primary))),
      ],
      onChanged: (String? mode) {
        if (mode != null) {
          themeProvider.toggle(mode == "dark");
        }
      },
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2))),
    );
  }
}
