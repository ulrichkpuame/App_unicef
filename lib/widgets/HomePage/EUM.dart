import 'package:flutter/material.dart';
import 'package:unicefapp/ui/pages/EUM/eum.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';

Widget EUM(BuildContext context) => InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EUMPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Defaults.bluePrincipal,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 25,
                child: Icon(
                  Icons.message_rounded,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "EUM",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "End User Monitoring",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
