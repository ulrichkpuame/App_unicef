// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Acknowledge.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Inventory.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Issues.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Trace.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Transfer.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/mydrawer.dart';

class SupplyLogisticPage extends StatelessWidget {
  const SupplyLogisticPage({super.key});

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
                'Transaction',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Logistics Transactions',
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
      body: Column(
        children: [
          Expanded(
              child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: .85,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Transfer(context),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Acknowledge(context),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Issues(context),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Trace(context),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Inventory(context),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Dispatch(context),
              // ),
            ],
          )),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Trackit EUM mobile application",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
