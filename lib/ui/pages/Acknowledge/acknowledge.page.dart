// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/history.transfer.dart';
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/ui/pages/Acknowledge/acknowledge.details.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AcknowledgePage extends StatefulWidget {
  const AcknowledgePage({
    Key? key,
  }) : super(key: key);

  @override
  _AcknowledgePageState createState() => _AcknowledgePageState();
}

class _AcknowledgePageState extends State<AcknowledgePage> {
  List<HistoryTransfer> tableData = [];
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) => _getAcknoledge(
        value!.roles.elementAt(0) == 'ROLE_IP' ? value.organisation : 'all'));
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  void _getAcknoledge(String orgId) async {
    // try {
    var response = await http.get(
        Uri.parse('https://www.trackiteum.org/u/admin/acknowledge/$orgId'),
        headers: {
          "Content-type": "application/json",
        });
    print(response.body);
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      var apiResponse = List<HistoryTransfer>.from(
          jsonResponse.map((e) => HistoryTransfer.fromJson(e)).toList());
      setState(() {
        tableData = apiResponse;
      });
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
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
                          builder: (context) => const SupplyLogisticPage()),
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
                AppLocalizations.of(context)!.acknowledgeTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
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
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: DataTable(
                  dividerThickness: 5,
                  horizontalMargin: 10,
                  dataRowHeight: 50,
                  showBottomBorder: true,
                  headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Defaults.bluePrincipal),
                  headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Defaults.white),
                  columns: [
                    DataColumn(
                        label: Text(
                      AppLocalizations.of(context)!.ip,
                      style: TextStyle(fontSize: 12),
                    )),
                    DataColumn(
                        label: Text(
                      AppLocalizations.of(context)!.date,
                      style: TextStyle(fontSize: 12),
                    )),
                    DataColumn(
                        label: Text(
                      AppLocalizations.of(context)!.type,
                      style: TextStyle(fontSize: 12),
                    )),
                    DataColumn(
                        label: Text(
                      AppLocalizations.of(context)!.doc,
                      style: TextStyle(fontSize: 12),
                    )),
                    DataColumn(
                        label: Text(
                      AppLocalizations.of(context)!.status,
                      style: TextStyle(fontSize: 12),
                    )),
                  ],
                  rows: tableData.map((data) {
                    return DataRow(
                        onLongPress: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AcknowledgeDetailsPage(
                                        historyTransfer: data,
                                      )));
                        },
                        cells: [
                          DataCell(Text(data.ipName)),
                          DataCell(Text(data.initiatingDate)),
                          DataCell(Text(data.typeOfTransfer)),
                          DataCell(Text(data.documentNumber)),
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
