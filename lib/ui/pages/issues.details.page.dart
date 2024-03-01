// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IssuesDetailsPage extends StatefulWidget {
  const IssuesDetailsPage({super.key, required this.issue});

  final Issue issue;

  @override
  State<IssuesDetailsPage> createState() => _IssuesDetailsPageState();
}

class _IssuesDetailsPageState extends State<IssuesDetailsPage> {
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _selectedValue = TextEditingController();
  List<String> listOfValue = [
    'OPEN ',
    'CLOSED',
  ];
  String idIssue = '';
  String closedById = '';
  String closedByName = '';
  String BASEURL = 'https://www.trackiteum.org';

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) {
      closedById = value!.id;
      closedByName = '${value.firstname} ${value.lastname}';
    });
    idIssue = widget.issue.id;
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  Widget build(BuildContext context) {
    void _submitStatus() async {
      var url = '$BASEURL/u/admin/issues/update/$idIssue';

      // Effectuer l'appel à l'API avec les données saisies
      print(url);
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-type": "application/json",
          },
          body: jsonEncode({
            "status": _selectedValue.text,
            "comment": _commentController.text,
            "closedById": closedById,
            "closedByName": closedByName,
          }));
      print(response.body);
      print(_selectedValue);
      if (response.statusCode == 200) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.sucess,
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
                  Text(
                    AppLocalizations.of(context)!.issuSuccessMsg,
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
                  child: Text(AppLocalizations.of(context)!.goBack))
            ],
          ),
        );
      } else {
        setState(() {
          AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.error,
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
                  Text(
                    AppLocalizations.of(context)!.issuErrorMsg,
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
                  child: Text(AppLocalizations.of(context)!.retry))
            ],
          );
        });
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
                      MaterialPageRoute(
                          builder: (context) => const IssuesPage()),
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
                AppLocalizations.of(context)!.issueTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.issueSubTitle,
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
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        AppLocalizations.of(context)!.commentaire,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    controller: _commentController,
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
                    value: _selectedValue.text.isNotEmpty
                        ? _selectedValue.text
                        : null,
                    hint: Text(
                      AppLocalizations.of(context)!.selectfromthelist,
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue.text = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.cantEmpty;
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
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitStatus();
              },
              child: Text(AppLocalizations.of(context)!.submit),
            ),
          ],
        ),
      ),
    );
  }
}
