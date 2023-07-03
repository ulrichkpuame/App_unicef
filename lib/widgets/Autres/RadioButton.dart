import 'package:flutter/material.dart';

Widget RadioButton(BuildContext context, TextEditingController controller) {
  int? selectedValue;

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    // setState(() {
                    selectedValue = value;
                    controller.text = 'Yes';
                    // });
                  },
                ),
                const Expanded(
                  child: Text('Yes'),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Radio(
                  value: 2,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    // setState(() {
                    selectedValue = value;
                    controller.text = 'No';
                    // });
                  },
                ),
                const Expanded(
                  child: Text('No'),
                )
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
