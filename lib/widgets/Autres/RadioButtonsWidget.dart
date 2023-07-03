import 'package:flutter/material.dart';

class RadioButtonsWidget extends StatefulWidget {
  TextEditingController? radioButtoncontroller;
  @override
  _RadioButtonsWidgetState createState() => _RadioButtonsWidgetState();
}

class _RadioButtonsWidgetState extends State<RadioButtonsWidget> {
  //late TextEditingController radioButtoncontroller;
  int? selectedValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      setState(() {
                        selectedValue = value;
                        // radioButtoncontroller.text = 'Yes';
                      });
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
                      setState(() {
                        selectedValue = value;
                        // radioButtoncontroller.text = 'No';
                      });
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
}
