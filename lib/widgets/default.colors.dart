import 'package:flutter/material.dart';

class Defaults {
  static const MaterialColor primaryBleuColor = MaterialColor(
    0xFF00C0F0,
    <int, Color>{
      50: Color(0xFF00C0F0),
      100: Color(0xFF00C0F0),
      200: Color(0xFF00C0F0),
      300: Color(0xFF00C0F0),
      400: Color(0xFF00C0F0),
      500: Color(0xFF00C0F0),
      600: Color(0xFF00C0F0),
      700: Color(0xFF00C0F0),
      800: Color(0xFF00C0F0),
      900: Color(0xFF00C0F0),
    },
  );
  static const MaterialColor primaryGreenColor = MaterialColor(
    0xFF14c9a6,
    <int, Color>{
      50: Color(0xFF14c9a6),
      100: Color(0xFF14c9a6),
      200: Color(0xFF14c9a6),
      300: Color(0xFF14c9a6),
      400: Color(0xFF14c9a6),
      500: Color(0xFF14c9a6),
      600: Color(0xFF14c9a6),
      700: Color(0xFF14c9a6),
      800: Color(0xFF14c9a6),
      900: Color(0xFF14c9a6),
    },
  );
  static const Color greenPrincipal = Color(0xFF14c9a6);
  static const Color greenSelected = Color(0xFF59f1d3);
  static const Color bluePrincipal = Color(0xFF00C0F0);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color blackWhite = Color.fromARGB(255, 48, 46, 46);
  static const Color blueSecond = Color.fromRGBO(194, 230, 255, 1);
  static const Color blueFondCadre = Color(0xFFe8f6f9);
  static const Color blueSelected = Color(0xFF70cdee);
  static const Color appbarColors = Color.fromARGB(255, 255, 255, 255);
  static const Color orangeColor = Color(0xFFE68342);
  static const Color greenMenuColor = Color.fromARGB(255, 44, 98, 82);
  static const Color greenMenuWhiteColor = Color.fromARGB(255, 166, 230, 211);

  static const kBackgroundColor = Color(0xFFF8F8F8);
  static const kActiveIconColor = Color(0xFFE68342);
  static const kTextColor = Color(0xFF222B45);
  static const kBlueLightColor = Color(0xFFC7B8F5);
  static const kBlueColor = Color(0xFF817DC0);
  static const kShadowColor = Color(0xFFE6E6E6);

  static const Color drawerItemColor = bluePrincipal;
  static const Color drawerItemSelectedColor = black; //Colors.blue[700];
  static const Color drawerSelectedTileColor = blueSecond; //Colors.blue[100];

  static final drawerItemText = [
    'Supply & Login',
    'Acknowledge',
    'Inventory',
    'Settings',
    'Report',
  ];

  static final drawerItemIcon = [
    Icons.send,
    Icons.note_add_rounded,
    Icons.note_alt_sharp,
    Icons.settings,
    Icons.bar_chart,
  ];
}
