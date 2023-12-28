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
        bodyLarge: TextStyle(color: Colors.black),//GoogleFonts.aBeeZee(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),//GoogleFonts.aBeeZee(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),//GoogleFonts.aBeeZee(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black),//GoogleFonts.aBeeZee(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),//GoogleFonts.aBeeZee(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black)//GoogleFonts.aBeeZee(color: Colors.black),
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