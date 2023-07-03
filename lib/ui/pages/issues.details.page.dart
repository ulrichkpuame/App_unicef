// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/issues.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/ui/pages/issues.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:http/http.dart' as http;
import 'package:unicefapp/widgets/loading.indicator.dart';

class IssuesDetailsPage extends StatefulWidget {
  const IssuesDetailsPage({super.key, required this.issue});

  final Issue issue;

  @override
  State<IssuesDetailsPage> createState() => _IssuesDetailsPageState();
}

class _IssuesDetailsPageState extends State<IssuesDetailsPage> {
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) => print(value));
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  Widget build(BuildContext context) {
    String? _selectedValue;
    List<String> listOfValue = [
      'OPEN ',
      'CLOSED',
    ];

    void _submitStatus() async {
      var url = 'https://votre-api.com/table-data';

      // Effectuer l'appel à l'API avec les données saisies
      print(url);
      var response = await http.get(Uri.parse(url), headers: {
        "Content-type": "application/json",
      });
      if (response.statusCode == 200) {
        print(response.body);
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text('ISSUE',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                          'Status updated Successfull',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ))),
              ),
              const SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
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
            builder: (ctx) => AlertDialog(
              title: const Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text('ISSUE',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
              content: Lottie.asset(
                'animations/error-dialog.json',
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
                            'Status not updated',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ))),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
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
        });
        print(response.body);
      }
    }

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
                      MaterialPageRoute(builder: (context) => IssuesPage()),
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
                'Issue',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Set status',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  FutureBuilder<Agent?>(
                      future: _futureAgentConnected,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            Text(
                                snapshot.hasData
                                    ? '${snapshot.data!.lastname} ${snapshot.data!.firstname}'
                                    : '',
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Defaults.black)),
                            const SizedBox(
                              height: 10,
                            ),
                            // Text(
                            //     snapshot.hasData
                            //         ? '${snapshot.data!.email}'
                            //         : '',
                            //     style: const TextStyle(
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.w500,
                            //         color: Colors.black)),
                          ],
                        );
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Commentaire',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    //controller: _textController8,
                    autocorrect: false,
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Defaults.white,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Defaults.white), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Defaults.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      fillColor: Defaults.white,
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Defaults.white, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Defaults.white, width: 2),
                      ),
                    ),
                    value: _selectedValue,
                    hint: Text(
                      'Set status',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "can't empty";
                      } else {
                        return null;
                      }
                    },
                    items: listOfValue.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitStatus();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
