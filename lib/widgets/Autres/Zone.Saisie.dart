import 'package:flutter/material.dart';
import 'package:unicefapp/widgets/default.colors.dart';

Widget ZoneSaisie(BuildContext context, TextEditingController controller) {
  return Container(
    height: 50,
    child: TextFormField(
      controller: controller,
      autocorrect: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Defaults.white,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(width: 1, color: Defaults.white), //<-- SEE HERE
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Defaults.white),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
