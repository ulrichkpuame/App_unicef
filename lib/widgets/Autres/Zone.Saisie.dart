import 'package:flutter/material.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget ZoneSaisie(BuildContext context, TextEditingController controller) {
  return SizedBox(
    height: 50,
    child: TextFormField(
      controller: controller,
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Defaults.white,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Defaults.white),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Defaults.white),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.fillField;
        }
        return null;
      },
    ),
  );
}
