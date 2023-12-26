// ignore_for_file: unused_local_variable, unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/stock.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';

import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DispatchPage extends StatefulWidget {
  const DispatchPage({super.key});

  @override
  _DispatchPageState createState() => _DispatchPageState();
}

class _DispatchPageState extends State<DispatchPage> {
  final _formKey = GlobalKey<FormState>();
  List<Stock> tableData = [];

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController batchNumberController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  //TextEditingController materialController = TextEditingController();

  String? materialController;
  String serderName = '';
  String senderEmail = '';
  String senderPhone = '';
  String ip = '';
  String description = '';

  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) {
      _getInventory(value!.organisation);
      serderName = '${value.firstname} ${value.lastname}';
      senderEmail = value.email;
      senderPhone = value.telephone;
      ip = value.organisation;
    });
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  String _getDescription(List<Stock> list, String value) {
    String description = '';
    List<Stock> stocks = List<Stock>.from(list);
    stocks.retainWhere((element) => element.material == value);
    description = list.elementAt(0).materialDescription;
    return description;
  }

  void _getInventory(String AgentId) async {
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

  void _submitDispatch() async {
    // Effectuer l'appel à l'API pour récupérer les données du tableau
    var response = await http.post(
        Uri.parse('https://www.trackiteum.org/u/admin/dispatch/save'),
        headers: {
          "Content-type": "application/json",
        },
        body: jsonEncode({
          'material': materialController,
          'description': description,
          'beneficiaryPhone': phoneNumberController.text,
          'beneficaryName': fullNameController.text,
          'beneficiaryEmail': emailController.text,
          'quantity': quantityController.text,
          'senderName': serderName,
          'senderEmail': senderEmail,
          'senderPhone': senderPhone,
          'dateCreateDispatch': DateTime.now().toString(),
          'ip': ip,
          'batchid': batchNumberController.text
        }));

    ///-------- POPU UP OF SUCCESS ---------//
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
                  AppLocalizations.of(context)!.succesDispatchMsg,
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
                  AppLocalizations.of(context)!.errorDispatchMsg,
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
          title: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.dispatchTitle,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.dispatchSubTitle,
                style: const TextStyle(
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
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 23, top: 8.0, right: 8.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context)!.receiverInfo,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(AppLocalizations.of(context)!.enterFullName),
              ),
              const SizedBox(
                height: 4,
              ),
              ZoneSaisie(context, fullNameController),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(AppLocalizations.of(context)!.enterEmail),
              ),
              const SizedBox(
                height: 4,
              ),
              ZoneSaisie(context, emailController),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(AppLocalizations.of(context)!.enterPhoneNumber),
              ),
              const SizedBox(
                height: 4,
              ),
              ZoneSaisie(context, phoneNumberController),
              const SizedBox(
                height: 13,
              ),
              const Divider(
                height: 8,
                color: Colors.grey,
                endIndent: 10,
                indent: 10,
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 23, top: 8.0, right: 8.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context)!.materialInfo,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 15),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: DropdownButton<String>(
                    value: materialController,
                    hint: Text(AppLocalizations.of(context)!.selectMaterial),
                    items: tableData.map((e) {
                      return DropdownMenuItem(
                        value: e.material,
                        child: Text(e.materialDescription),
                      );
                    }).toList(),
                    underline: const SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        materialController = value;
                        description = _getDescription(tableData, value!);
                      });
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(AppLocalizations.of(context)!.enterBatchNumber),
              ),
              const SizedBox(
                height: 4,
              ),
              ZoneSaisie(context, batchNumberController),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(AppLocalizations.of(context)!.enterQuantity),
              ),
              const SizedBox(
                height: 4,
              ),
              ZoneSaisie(context, quantityController),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _submitDispatch,
                    child: Text(AppLocalizations.of(context)!.send,
                        style: TextStyle(fontSize: 15, color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
