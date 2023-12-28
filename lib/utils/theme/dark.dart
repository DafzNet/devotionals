import '../constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      primaryColorLight: Colors.white,
      primarySwatch: cricColor,
      scaffoldBackgroundColor: Colors.black,

      textTheme: TextTheme(
        bodyLarge: GoogleFonts.poppins(color: Colors.white),
        bodyMedium: GoogleFonts.poppins(color: Colors.white),
        bodySmall: GoogleFonts.poppins(color: Colors.white),
        titleLarge: GoogleFonts.poppins(color: Colors.white),
        titleMedium: GoogleFonts.poppins(color: Colors.white),
        titleSmall: GoogleFonts.poppins(color: Colors.white),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        )
      ),

      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.tealAccent,
        textTheme: ButtonTextTheme.primary,
      ),
    );