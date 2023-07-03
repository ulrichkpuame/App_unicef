import 'package:flutter/material.dart';
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/ui/pages/transfer.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';

Widget Transfer(BuildContext context) => InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TransactionPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: Icon(
                  Icons.car_repair_rounded,
                  color: Colors.black,
                  size: 35,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "TRANSFER",
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
                "Transfer from IP",
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
