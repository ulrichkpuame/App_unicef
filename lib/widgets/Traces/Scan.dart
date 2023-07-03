import 'package:flutter/material.dart';
import 'package:unicefapp/ui/pages/scan.trace.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';

Widget Scan(BuildContext context) => InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScanTracePage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Defaults.greenMenuColor,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                child: Icon(
                  Icons.scanner,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "SCAN",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Scan product",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
