import 'package:flutter/material.dart';
import 'package:unicefapp/ui/pages/setting.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget settingsIP(BuildContext context) => InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Defaults.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.settings,
                size: 50,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.setTitle,
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
                AppLocalizations.of(context)!.setSubTitle,
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
