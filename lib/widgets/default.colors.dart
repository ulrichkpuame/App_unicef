import 'package:flutter/material.dart';

class Defaults {
  static const MaterialColor primaryBleuColor = MaterialColor(
    0xFF0f5169,
    <int, Color>{
      50: Color(0xFF0f5169),
      100: Color(0xFF0f5169),
      200: Color(0xFF0f5169),
      300: Color(0xFF0f5169),
      400: Color(0xFF0f5169),
      500: Color(0xFF0f5169),
      600: Color(0xFF0f5169),
      700: Color(0xFF0f5169),
      800: Color(0xFF0f5169),
      900: Color(0xFF0f5169),
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
  static const Color bluePrincipal = Color(0xFF0f5169);
  static const Color blueFondCadre = Color(0xFFe8f6f9);
  static const Color blueSelected = Color(0xFF70cdee);

  static const Color drawerItemColor = bluePrincipal;
  static const Color drawerItemSelectedColor =
      bluePrincipal; //Colors.blue[700];
  static const Color drawerSelectedTileColor = blueSelected; //Colors.blue[100];

  static final drawerItemText = [
    'Supply & Login',
    'Transfer',
    'Acknowledge',
    'Trace',
    'Issue',
    'Inventory',
    'EUM',
    'PVM',
  ];

  static final drawerItemIcon = [
    Icons.home,
    Icons.list,
    Icons.monetization_on,
    Icons.send,
    Icons.send,
    Icons.send,
    Icons.send,
    Icons.send,
  ];
}
