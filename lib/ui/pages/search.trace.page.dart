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
import 'package:unicefapp/widgets/loading.indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  late final Future<Agent?> _futureAgentConnected;

  @override
  void initState() {
    getAgent().then((value) => userId = value!.id);
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  void _getTrace() async {
    var response = await http.get(
        Uri.parse('https://www.trackiteum.org/u/admin/trace/$searchController'),
        headers: {
          "Content-type": "application/json",
        });
    if (response.statusCode == 200) {
      print("data ok");
    } else {
      print("not found");
    }
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
          title: const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text('TRACE',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          content: Lottie.asset(
            'animations/success.json',
            repeat: true,
            reverse: true,
            fit: BoxFit.cover,
          ),
          actions: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Item found',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ))),
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: () {
                          LoadingIndicatorDialog().show(context);
                          LoadingIndicatorDialog().dismiss();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => TracePage()));
                        },
                        child: const Text('Go Back')),
                  ),
                )),
          ],
        ),
      );
    } else {
      setState(() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text('TRACE',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            content: Lottie.asset(
              'animations/not_found.json',
              repeat: true,
              reverse: true,
              fit: BoxFit.cover,
            ),
            actions: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Expanded(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Item not found',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ))),
              ),
              const SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          onPressed: () {
                            LoadingIndicatorDialog().show(context);
                            LoadingIndicatorDialog().dismiss();

                            //---- RESTER SUR LA MEME PAGE ---//
                            // Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => TracePage()));
                          },
                          child: const Text('Go Back')),
                    ),
                  )),
            ],
          ),
        );
      });
    }
  }

  void _submitTrace() async {
    // Effectuer l'appel à l'API pour récupérer les données du tableau
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.trackiteum.org/u/admin/trace/$userId'));

    request.fields["batchid"] = searchController.text;
    // send
    var response = await request.send();
    print(response.statusCode);
    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

    ///-------- POPU UP OF SUCCESS ---------//
    if (response.statusCode == 200) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text('TRACE',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          content: Lottie.asset(
            'animations/success.json',
            repeat: true,
            reverse: true,
            fit: BoxFit.cover,
          ),
          actions: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Item found',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ))),
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: () {
                          LoadingIndicatorDialog().show(context);
                          LoadingIndicatorDialog().dismiss();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()));
                        },
                        child: const Text('Go Back')),
                  ),
                )),
          ],
        ),
      );
    } else {
      setState(() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text('TRACE',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            content: Lottie.asset(
              'animations/not_found.json',
              repeat: true,
              reverse: true,
              fit: BoxFit.cover,
            ),
            actions: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Expanded(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Item not found',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ))),
              ),
              const SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          onPressed: () {
                            LoadingIndicatorDialog().show(context);
                            LoadingIndicatorDialog().dismiss();

                            //---- RESTER SUR LA MEME PAGE ---//
                            // Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => TracePage()));
                          },
                          child: const Text('Go Back')),
                    ),
                  )),
            ],
          ),
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
                      MaterialPageRoute(builder: (context) => TracePage()),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Defaults.bluePrincipal,
                  )),
            ],
          ),
          title: const Column(
            children: [
              Text(
                'Search',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Search batch number',
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text('Enter Batch Number')),
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
                label: const Text('Search'))
          ],
        ),
      ),
    );
  }
}
