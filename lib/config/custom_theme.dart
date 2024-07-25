import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/constants/color_path.dart';

class CustomTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.ebGaramond().fontFamily,
        colorScheme: ColorScheme.fromSeed(
            seedColor: TodoColors.primaryColor,
            secondary: TodoColors.secondaryColor,
            error: Colors.red,
            onTertiary: TodoColors.secondaryDarkColor),
        scaffoldBackgroundColor: TodoColors.secondaryDarkColor,
        appBarTheme: const AppBarTheme(
            backgroundColor: TodoColors.secondaryDarkColor,
            iconTheme: IconThemeData(color: TodoColors.lightWhiteColor)),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: TodoColors.backgroundDarkColor,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.white,
            unselectedItemColor: TodoColors.greyColor,
            selectedLabelStyle: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Colors.white,
                    )),
            unselectedLabelStyle: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: TodoColors.greyColor,
                    ))));
  }

  static ThemeData darkThemeData() {
    return ThemeData();
  }
}
