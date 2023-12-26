import 'package:flutter/material.dart';
import 'package:unicefapp/ui/pages/search.trace.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget Search(BuildContext context) => InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchTracePage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Defaults.greenMenuColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                child: Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.searchTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.searchSub,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
