import 'package:flutter/material.dart';

const MaterialColor teal = MaterialColor(_tealPrimaryValue, <int, Color>{
  50: Color(0xFFECF6F9),
  100: Color(0xFFD0E9EF),
  200: Color(0xFFB1DBE5),
  300: Color(0xFF91CCDB),
  400: Color(0xFF7AC1D3),
  500: Color(_tealPrimaryValue),
  600: Color(0xFF5AAFC6),
  700: Color(0xFF50A6BE),
  800: Color(0xFF469EB8),
  900: Color(0xFF348EAC),
});
const int _tealPrimaryValue = 0xFF62B6CB;

const MaterialColor background =
    MaterialColor(_backgroundPrimaryValue, <int, Color>{
  50: Color(0xFFFEFEFE),
  100: Color(0xFFFEFEFE),
  200: Color(0xFFFDFDFD),
  300: Color(0xFFFCFCFC),
  400: Color(0xFFFBFBFB),
  500: Color(_backgroundPrimaryValue),
  600: Color(0xFFF9F9F9),
  700: Color(0xFFF9F9F9),
  800: Color(0xFFF8F8F8),
  900: Color(0xFFF6F6F6),
});
const int _backgroundPrimaryValue = 0xFFFAFAFA;

const MaterialColor navy = MaterialColor(_navyPrimaryValue, <int, Color>{
  50: Color(0xFFE4E9ED),
  100: Color(0xFFBBC8D1),
  200: Color(0xFF8DA4B2),
  300: Color(0xFF5F8093),
  400: Color(0xFF3D647C),
  500: Color(_navyPrimaryValue),
  600: Color(0xFF18425D),
  700: Color(0xFF143953),
  800: Color(0xFF103149),
  900: Color(0xFF082137),
});
const int _navyPrimaryValue = 0xFF1B4965;

// Note: checkbox outlines are 100%, but symptom box outlines are 25%

const MaterialColor blue = MaterialColor(_bluePrimaryValue, <int, Color>{
  50: Color(0xFFECF5FA),
  100: Color(0xFFCFE5F2),
  200: Color(0xFFAFD4E9),
  300: Color(0xFF8FC2E0),
  400: Color(0xFF77B5DA),
  500: Color(_bluePrimaryValue),
  600: Color(0xFF57A0CE),
  700: Color(0xFF4D97C8),
  800: Color(0xFF438DC2),
  900: Color(0xFF327DB7),
});
const int _bluePrimaryValue = 0xFF5FA8D3;

// these are used for symptoms box insides

const MaterialColor boxinsides =
    MaterialColor(_boxinsidesPrimaryValue, <int, Color>{
  50: Color(0xFFFCFEFF),
  100: Color(0xFFF8FCFE),
  200: Color(0xFFF3FAFE),
  300: Color(0xFFEEF7FE),
  400: Color(0xFFEBF6FD),
  500: Color(_boxinsidesPrimaryValue),
  600: Color(0xFFE4F3FD),
  700: Color(0xFFE0F1FC),
  800: Color(0xFFDDEFFC),
  900: Color(0xFFD7ECFC),
});
const int _boxinsidesPrimaryValue = 0xFFE7F4FD;

const MaterialColor white = MaterialColor(_whitePrimaryValue, <int, Color>{
  50: Color(0xFFFFFFFF), // You can adjust shades of white if needed
  100: Color(0xFFFFFFFF),
  200: Color(0xFFFFFFFF),
  300: Color(0xFFFFFFFF),
  400: Color(0xFFFFFFFF),
  500: Color(_whitePrimaryValue),
  600: Color(0xFFFFFFFF),
  700: Color(0xFFFFFFFF),
  800: Color(0xFFFFFFFF),
  900: Color(0xFFFFFFFF),
});
const int _whitePrimaryValue = 0xFFFFFFFF;
