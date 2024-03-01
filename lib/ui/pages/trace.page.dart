// ignore_for_file: deprecated_member_use, unused_local_variable, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:http/http.dart' as http;
import 'package:unicefapp/models/dto/trace.dart';
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/ui/pages/search.trace.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'dart:convert';

import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TracePage extends StatefulWidget {
  const TracePage({super.key});

  @override
  _TracePageState createState() => _TracePageState();
}

class _TracePageState extends State<TracePage> {
  List<Trace> tableData = [];

  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;
  String BASEURL = 'https://www.trackiteum.org';
  // bool selected = true;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) {
      _fetchIssue(value!.country);
    });
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  void _fetchIssue(String userCountry) async {
    // Effectuer l'appel à l'API pour récupérer les données du tableau
    var response = await http
        .get(Uri.parse('$BASEURL/u/admin/trace/list/$userCountry'), headers: {
      "Content-type": "application/json",
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<Trace> data = [];

      for (var item in jsonResponse) {
        var apiResponse = Trace.fromJson(item);
        data.add(apiResponse);
      }

      setState(() {
        tableData = data;
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
                AppLocalizations.of(context)!.trace,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.traceSubTitle,
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
      floatingActionButton: SpeedDial(
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: Defaults.bluePrincipal, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor:
            Defaults.bluePrincipal, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.search),
            backgroundColor: Colors.white,
            label: AppLocalizations.of(context)!.searchTrace,
            labelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SearchTracePage())),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Défilement vertical pour la colonne
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection:
                Axis.horizontal, // Défilement horizontal pour les lignes
            child: DataTable(
              dividerThickness: 5,
              dataRowHeight: 50,
              showBottomBorder: true,
              headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Defaults.bluePrincipal),
              headingRowColor:
                  MaterialStateProperty.resolveWith((states) => Defaults.white),
              columns: [
                DataColumn(
                    label: Text(AppLocalizations.of(context)!.recordedOn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.material)),
                DataColumn(label: Text(AppLocalizations.of(context)!.ipName)),
                DataColumn(label: Text(AppLocalizations.of(context)!.batchId)),
                DataColumn(
                    label: Text(AppLocalizations.of(context)!.receivedOn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.coment)),
              ],
              rows: tableData.map((data) {
                return DataRow(cells: [
                  DataCell(Text(data.recordDate.toString())),
                  DataCell(Text(data.materialDescription.toString())),
                  DataCell(Text(data.ipName.toString())),
                  DataCell(Text(data.batchID.toString())),
                  DataCell(Text(data.dateOfReception.toString())),
                  DataCell(Text(data.comment.toString())),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
