import '../constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.white,
      primaryColorLight: Colors.black,
      primarySwatch: cricColor,
      scaffoldBackgroundColor: Colors.white,

      textTheme: TextTheme(
        bodyLarge: GoogleFonts.merriweather(color: Colors.black, fontSize: 16),
        bodyMedium: GoogleFonts.merriweather(color: Colors.black, fontSize: 16),
        bodySmall: GoogleFonts.merriweather(color: Colors.black, fontSize: 14),
        titleLarge: GoogleFonts.merriweather(color: Colors.black, fontSize: 20),
        titleMedium: GoogleFonts.merriweather(color: Colors.black, fontSize: 18),
        titleSmall:GoogleFonts.merriweather(color: Colors.black, fontSize: 16),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark
        )
      ),

      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.tealAccent,
        textTheme: ButtonTextTheme.primary,
      ),
    );