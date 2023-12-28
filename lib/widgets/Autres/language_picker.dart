import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicefapp/l10n/l10n.dart';
import 'package:unicefapp/provider/locale_provider.dart';

// class LanguageWidget extends StatelessWidget {
//   const LanguageWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final locale = Localizations.localeOf(context);
//     final flag = L10n.getFlag(locale.languageCode);
//     return CircleAvatar(
//       backgroundColor: Colors.white,
//       radius: 72,
//       child: Text(
//         flag,
//       ),
//     );
//   }
// }

class LanguagePickerWidget extends StatelessWidget {
  const LanguagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('en');

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale,
        icon: Container(width: 12),
        items: L10n.all.map(
          (locale) {
            final flag = L10n.getFlag(locale.languageCode);

            return DropdownMenuItem(
              child: Center(
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 32),
                ),
              ),
              value: locale,
              onTap: () {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);

                provider.setLocale(locale);
              },
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
