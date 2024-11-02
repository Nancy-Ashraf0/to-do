import 'package:flutter/material.dart';
import 'package:to_do_app/utils/app_colors.dart';
import 'app_styles.dart';

abstract class AppTheme {
  static ThemeData light = ThemeData(
    iconTheme: IconThemeData(color: AppColors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      titleTextStyle: AppStyles.appBar,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 2,
        backgroundColor: AppColors.white,
        unselectedItemColor: AppColors.unSelectedIcon,
        selectedItemColor: AppColors.primary),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: AppColors.primary),
    textTheme: TextTheme(
        titleLarge: AppStyles.task.copyWith(color: AppColors.primary),
        titleMedium: AppStyles.task.copyWith(color: AppColors.green),
        headlineSmall: AppStyles.appBar.copyWith(color: AppColors.white),
        headlineMedium: AppStyles.done,
        labelSmall: AppStyles.typographyInter.copyWith(color: AppColors.black),
        displaySmall: AppStyles.roboto,
        titleSmall: AppStyles.inter,
        bodySmall: AppStyles.date.copyWith(color: AppColors.black)),
    scaffoldBackgroundColor: AppColors.background,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.white),
  );
  static ThemeData dark = ThemeData(
      iconTheme: IconThemeData(color: AppColors.black),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        titleTextStyle: AppStyles.appBar.copyWith(color: AppColors.darkBlue),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkShadeBlue,
          unselectedItemColor: AppColors.unSelectedIcon,
          selectedItemColor: AppColors.primary),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: AppColors.primary),
      scaffoldBackgroundColor: AppColors.darkBlue,
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: AppColors.darkShadeBlue),
      textTheme: TextTheme(
          titleLarge: AppStyles.task.copyWith(color: AppColors.primary),
          titleMedium: AppStyles.task.copyWith(color: AppColors.green),
          headlineSmall: AppStyles.appBar.copyWith(color: AppColors.black),
          headlineMedium: AppStyles.done,
          labelSmall:
              AppStyles.typographyInter.copyWith(color: AppColors.white),
          displaySmall: AppStyles.roboto,
          titleSmall: AppStyles.inter,
          bodySmall: AppStyles.date.copyWith(color: AppColors.white)));
}
