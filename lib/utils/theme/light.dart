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
      scaffoldBackgroundColor: Colors.grey[100],

      textTheme: TextTheme(
        bodyLarge: GoogleFonts.openSans (color: Colors.black, fontSize: bodyFontLarge),
        bodyMedium: GoogleFonts.openSans(color: Colors.black, fontSize: bodyFontMedium),
        bodySmall: GoogleFonts.openSans(color: Colors.black, fontSize: bodyFontSmall),
        titleLarge: GoogleFonts.openSans(color: Colors.black, fontSize: titleFontLarge),
        titleMedium: GoogleFonts.openSans(color: Colors.black, fontSize: titleFontMedium),
        titleSmall:GoogleFonts.openSans(color: Colors.black, fontSize: titleFontSmall),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
        
      ),

      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.tealAccent,
        textTheme: ButtonTextTheme.primary,
      ),
    );