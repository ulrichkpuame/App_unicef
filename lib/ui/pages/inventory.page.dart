// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/inventory.dart';
import 'package:http/http.dart' as http;
import 'package:unicefapp/models/dto/stock.dart';
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'dart:convert';

import 'package:unicefapp/widgets/mydrawer.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Stock> tableData = [];
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;
  // bool selected = true;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) => _submitInventory(
        value!.roles.elementAt(0) == 'ROLE_IP' ? value.organisation : 'all'));
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  void _submitInventory(String AgentId) async {
    // Effectuer l'appel à l'API pour récupérer les données du tableau
    var response = await http.get(
        Uri.parse('https://www.trackiteum.org/u/admin/inventory/$AgentId'),
        headers: {
          "Content-type": "application/json",
        });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<Stock> data = [];

      for (var item in jsonResponse) {
        var apiResponse = Stock.fromJson(item);
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
                  icon: Icon(
                    Icons.arrow_back,
                    color: Defaults.bluePrincipal,
                  )),
            ],
          ),
          title: Column(
            children: const [
              Text(
                'INVENTORY',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Total Stocks Available',
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
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                horizontalMargin: 22,
                dividerThickness: 3,
                dataRowHeight: 60,
                showBottomBorder: true,
                headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Defaults.bluePrincipal),
                headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => Defaults.white),
                columns: const [
                  DataColumn(label: Text('Ip Name')),
                  DataColumn(label: Text('Material Description')),
                  DataColumn(label: Text('Qty')),
                ],
                rows: tableData.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data.ipName)),
                    DataCell(Text(data.materialDescription)),
                    DataCell(Text(data.quantity)),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
