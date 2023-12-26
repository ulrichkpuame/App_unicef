import 'package:flutter/material.dart';
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget supplyLogistic(BuildContext context) => InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SupplyLogisticPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Defaults.orangeColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 25,
                child: Icon(
                  Icons.car_repair_rounded,
                  color: Colors.black,
                  size: 35,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.supplyLogisticTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.supplyLogistics,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
