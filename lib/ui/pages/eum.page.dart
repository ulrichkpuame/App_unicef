// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/surveyExtraction.dart';
import 'package:unicefapp/ui/pages/eum.details.page.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EUMPage extends StatefulWidget {
  EUMPage({super.key});

  @override
  State<EUMPage> createState() => _EUMPageState();
}

class _EUMPageState extends State<EUMPage> {
  List<DTOSurveyExtration> tableData = [];
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;

  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) => _submitAcknoledge(value!.id));
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  void _submitAcknoledge(String userId) async {
    // try {
    var response = await http.get(
        Uri.parse('https://www.trackiteum.org/u/admin/eum/$userId'),
        headers: {
          "Content-type": "application/json",
        });
    print(response.body);
    print('HTTP-------- https://www.trackiteum.org/u/admin/eum/$userId');
    if (response.statusCode == 200) {
      // LoadingIndicatorDialog().show(context);
      Iterable jsonResponse = json.decode(response.body);
      var apiResponse = List<DTOSurveyExtration>.from(
          jsonResponse.map((e) => DTOSurveyExtration.fromJson(e)).toList());
      setState(() {
        // LoadingIndicatorDialog().dismiss();
        tableData = apiResponse;
      });
    } else {
      // setState(() {
      //   apiResult = 'Erreur lors de l\'appel à l\'API.';
      // });
      print(response.body);
    }
    // } on DioError catch (e) {
    //   LoadingIndicatorDialog().dismiss();
    //   ErrorDialog().show(e);
    // }
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
                      MaterialPageRoute(builder: (context) => const HomePage()),
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
                'EUM',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'End User Monitoring',
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
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: DataTable(
                  horizontalMargin: 40,
                  dividerThickness: 2,
                  dataRowHeight: 50,
                  showBottomBorder: true,
                  headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Defaults.bluePrincipal),
                  headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Defaults.white),
                  columns: const [
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: tableData.map((data) {
                    return DataRow(
                        onLongPress: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EUMDetailsPage(
                                        dtoSurveyExtration: data,
                                      )));
                        },
                        cells: [
                          DataCell(Text(data.title)),
                          DataCell(Text(data.category)),
                          DataCell(Text(data.status)),
                        ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
