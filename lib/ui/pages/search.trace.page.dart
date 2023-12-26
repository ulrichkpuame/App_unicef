// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/ui/pages/trace.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchTracePage extends StatefulWidget {
  const SearchTracePage({super.key});

  @override
  State<SearchTracePage> createState() => _SearchTracePageState();
}

class _SearchTracePageState extends State<SearchTracePage> {
  TextEditingController searchController = TextEditingController();

  String apiResult = '';
  String userId = '';
  final storage = locator<TokenStorageService>();

  @override
  void initState() {
    getAgent().then((value) => userId = value!.id);
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  void _SubmitTrace2() async {
    var response = await http.get(
        Uri.parse(
            'https://www.trackiteum.org/u/admin/trace/${searchController.text}/$userId'),
        headers: {
          "Content-type": "application/json",
        });

    ///-------- POPU UP OF SUCCESS ---------//
    if (response.statusCode == 200) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'SUCCESS',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                Lottie.asset(
                  'animations/success.json',
                  repeat: true,
                  reverse: true,
                  fit: BoxFit.cover,
                  height: 100,
                ),
                const Text(
                  "Search in progress, you'll receive an email once completed",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
                child: const Text('GO BACK'))
          ],
        ),
      );
    } else {
      setState(() {
        AlertDialog(
          title: const Text(
            'ERROR',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                Lottie.asset(
                  'animations/auth.json',
                  repeat: true,
                  reverse: true,
                  fit: BoxFit.cover,
                  height: 100,
                ),
                const Text(
                  'Item not found',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Retry'))
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Defaults.white,
          centerTitle: false,
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TracePage()),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Defaults.bluePrincipal,
                  )),
            ],
          ),
          title: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.searchTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.searchSubTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                'images/unicef1.png',
                width: 100.0,
                height: 100.0,
              ),
              onPressed: () {
                // Actions à effectuer lorsque le bouton est pressé
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child:
                        Text(AppLocalizations.of(context)!.enterBatchNumber)),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            ZoneSaisie(context, searchController),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
                onPressed: _SubmitTrace2,
                icon: const Icon(Icons.search),
                label: Text(AppLocalizations.of(context)!.searchButton))
          ],
        ),
      ),
    );
  }
}
