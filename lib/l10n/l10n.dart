import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('pt'),
    const Locale('fr'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'en':
        return '🇬🇧';
      case 'pt':
        return '🇵🇹';
      case 'fr':
        return '🇫🇷';
      default:
        return '🇬🇧'; // Drapeau générique pour les langues non spécifiées
    }
  }
}
