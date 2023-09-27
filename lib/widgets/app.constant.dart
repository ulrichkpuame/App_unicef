import 'package:unicefapp/models/dto/language.dart';

class AppConstants {
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: "en.png",
        languageName: 'English',
        languageCode: 'en',
        countryCode: 'US'),
    LanguageModel(
        imageUrl: "fr.png",
        languageName: 'Français',
        languageCode: 'fr',
        countryCode: 'FR'),
    LanguageModel(
        imageUrl: "prt.png",
        languageName: 'Portugais',
        languageCode: 'pt',
        countryCode: 'PRT'),
  ];
}
