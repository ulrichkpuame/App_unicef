// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/organisation.dart';
import 'package:unicefapp/models/dto/transfer.dart';
import 'package:unicefapp/models/dto/users.dart';
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  String? _selecPointOfContact;
  String? _drivingCompany;
  String? _selecDriver;
  TextEditingController zrost_ddelController = TextEditingController();
  TextEditingController zrostController = TextEditingController();
  TextEditingController carMatriculeController = TextEditingController();

  //----------TOKEN AND AGENT VARIABLE-----------
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;
  var token = '';

  String LOCAL_URL = "https://www.trackiteum.org";

  List<String> zrost_ddelControllerValue = ['zrost', 'ddel'];
  var ip = "";
  var consignee = "";
  var consigneeName = "";
  var phoneDriver = "";

  //SELECT STAFF LIST
  // List<String> _selectedItems = [];
  List<User> _staff = [];
  final List<String> _selectedStaff = [];
  final List<String> _selectedStaffWithId = [];
  String? _selection3;

  //DECLARATION POUR LISTE DE PARTNER
  List<User> arrIPpoc = [];

  //DECLARATION POUR DISPATCH AGENT
  List<Organisation> arrDispatch = [];

  //DECLARATION POUR SELECT DRIVER
  List<User> arrDriver = [];
  List<User> userList = [];

  String apiResult = '';
  String waybill = '';
  String supplier = '';
  String driver = '';
  String ipspoc = '';
  String matriculeVehicule = '';
  String senderName = '';
  String senderPhone = '';
  String senderEmail = '';
  List<String> cc = [];

  Future<int> _submitForm(String token) async {
    String byZrostDdel = zrost_ddelController.text.toLowerCase();
    String documentType =
        (byZrostDdel == 'zrost') ? 'waybill' : 'purchase document';
    String search = zrostController.text;

    // Effectuer l'appel à l'API avec les données saisies
    var response = await http.get(
        Uri.parse(
            'https://www.trackiteum.org/u/gettransfer/$byZrostDdel/$documentType/$search'),
        headers: {
          "Content-type": "application/json",
        });
    print(response.body);
    if (response.statusCode == 404) {
      print(response.body);
      return 0;
    }
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse['documents']);
      var apiResponse = Transfer.fromJson(jsonResponse);
      var dispatching = apiResponse.organisations.elementAt(0).name.toString();

      setState(() {
        apiResult = apiResponse.organisations.elementAt(0).name.toString();
        ip = apiResponse.documents.elementAt(0).consigneeName.toString();

        consignee = apiResponse.documents.elementAt(0).consignee.toString();
        consigneeName =
            apiResponse.documents.elementAt(0).consigneeName.toString();

        arrIPpoc = List<User>.from(apiResponse.users);
        arrIPpoc.retainWhere((e) => e.organisation_id == consignee);

        arrDispatch = List<Organisation>.from(apiResponse.organisations);
        arrDispatch.retainWhere((e) => e.type == "SUPPLIER");
        userList = List<User>.from(apiResponse.users);

        _staff = List<User>.from(apiResponse.users);
        _staff.retainWhere((e) => e.organisation.type == "UNICEF");
      });
      return 1;
    } else {
      setState(() {
        apiResult = 'Erreur lors de l\'appel à l\'API.';
      });
      return -1;
    }
  }

  void _submitTransfer() async {
    String byZrostDdel = zrost_ddelController.text.toLowerCase();
    String search = zrostController.text;

    var url = LOCAL_URL +
        '/u/api/public/logistics/transfer?source=' +
        byZrostDdel +
        "&waybill=" +
        search +
        "&supplier=" +
        _drivingCompany! +
        "&cc=" +
        _selectedStaffWithId.join(',') +
        "&driver=" +
        _selecDriver! +
        "&ipspoc=" +
        _selecPointOfContact! +
        "&ipspocEmail=" +
        _selecPointOfContact! +
        "&mlleVehicule=" +
        carMatriculeController.text +
        "&phoneDriver=" +
        carMatriculeController.text +
        "&senderName=" +
        senderName +
        "&senderPhone=" +
        senderPhone +
        "&senderEmail=" +
        senderEmail +
        "&consignee=" +
        consignee +
        "&consigneeName=" +
        consigneeName;

    // Effectuer l'appel à l'API avec les données saisies
    print(url);
    var response = await http.get(Uri.parse(url), headers: {
      "Content-type": "application/json",
    });
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
                  'Transfer was Successfull',
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
                  'Unuccessfull Transfer',
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
  void dispose() {
    zrost_ddelController.dispose();
    zrostController.dispose();
    carMatriculeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) => {
          senderName = (value!.firstname + ' ' + value.lastname),
          senderPhone = value.telephone,
          senderEmail = value.email
        });
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: const Column(
            children: [
              Text(
                'Transfer',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Transfer to patner',
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
      body: Container(
        height: 2000,
        decoration: const BoxDecoration(color: Defaults.blueFondCadre),
        child: Form(
          key: _formKey,
          child: Theme(
            data: ThemeData(primarySwatch: Defaults.primaryBleuColor),
            child: Stepper(
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep == 0) ...[
                      ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: const Text('Next',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                    ] else if (_currentStep == 3) ...[
                      ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Previous',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                      ElevatedButton(
                          onPressed: () {
                            _submitTransfer();
                          },
                          child: const Text('Send',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                    ] else ...[
                      ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Previous',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                      ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: const Text('Next',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                    ]
                  ],
                );
              },
              type: stepperType,
              physics: const ScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: continued,
              onStepCancel: cancel,
              steps: <Step>[
                //STEPPR POUR SEARCH TRANSACTION
                Step(
                  title: const Text('Search Transaction',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                fillColor: Defaults.white,
                                filled: true,
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Defaults.white, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Defaults.white, width: 2),
                                ),
                              ),
                              value: zrost_ddelController.text.isNotEmpty
                                  ? zrost_ddelController.text
                                  : null,
                              hint: const Text('Select zrost or ddel'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Select zrost or ddel';
                                }
                                return null;
                              },
                              items: zrost_ddelControllerValue
                                  .map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  zrost_ddelController.text = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Ajoutez les champs supplémentaires en fonction de la sélection
                            if (zrost_ddelController.text == 'zrost') ...[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: zrostController,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Defaults.white,
                                    border: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1,
                                          color: Defaults.white), //<-- SEE HERE
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Defaults.white),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: 'Enter waybill number',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter waybill number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                resultSearchDocument,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                            if (zrost_ddelController.text == 'ddel') ...[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: zrostController,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Defaults.white,
                                    border: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1,
                                          color: Defaults.white), //<-- SEE HERE
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Defaults.white),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: 'Enter purchase document',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter purchase document';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                resultSearchDocument,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),

                //STEPPR POUR SELECT PARTNER
                Step(
                  title: const Text('Select Partner',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: Text(
                          'IP : $ip',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Defaults.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: _selecPointOfContact,
                            hint: const Text('Select point of contact'),
                            items: arrIPpoc.map((e) {
                              return DropdownMenuItem(
                                value: '${e.firstname} ${e.lastname}',
                                child: Text('${e.firstname} ${e.lastname}'),
                              );
                            }).toList(),
                            underline: const SizedBox(),
                            onChanged: (value) {
                              setState(() {
                                _selecPointOfContact = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),

                //STEPPR POUR DISPATCH AGENT
                Step(
                  title: const Text('Select Dispatch Agent',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: DropdownButton<String>(
                            value: _drivingCompany,
                            hint: const Text('Select driving company'),
                            items: arrDispatch.map((e) {
                              return DropdownMenuItem(
                                value: e.id,
                                child: Text(e.name),
                              );
                            }).toList(),
                            underline: const SizedBox(),
                            onChanged: (value) {
                              setState(() {
                                _drivingCompany = value;
                                arrDriver = List<User>.from(userList);
                                arrDriver.retainWhere(
                                    (e) => e.organisation!.id == value);
                              });
                            },
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
                            value: _selecDriver,
                            hint: const Text('Select driver'),
                            items: arrDriver.map((e) {
                              return DropdownMenuItem(
                                value: e.id,
                                child: Text('${e.firstname} ${e.lastname}'),
                              );
                            }).toList(),
                            underline: const SizedBox(),
                            onChanged: (value) {
                              setState(() {
                                _selecDriver = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15, top: 15),
                          child: TextField(
                            controller: carMatriculeController,
                            decoration: const InputDecoration(
                              fillColor: Defaults.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              hintText: 'Enter car matricule',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2
                      ? StepState.complete
                      : StepState.disabled,
                ),

                //STEPPR POUR SELECT STAFF
                Step(
                  title: const Text('Select Staff',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: const Text(
                              'Selected Members:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            subtitle: Text(
                              _selectedStaff.join(', '),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: DropdownButton<String>(
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down_circle),
                              value: _selection3,
                              hint: const Text('Select users'),
                              items: _staff.map((e) {
                                return DropdownMenuItem<String>(
                                  value: '${e.firstname} ${e.lastname}@${e.id}',
                                  child: Text('${e.firstname} ${e.lastname}'),
                                );
                              }).toList(),
                              underline: const SizedBox(),
                              onChanged: (value) {
                                setState(() {
                                  if (_selectedStaff.contains(value!
                                      .split('@')
                                      .elementAt(0)
                                      .toString())) {
                                    _selectedStaff.remove(value
                                        .split('@')
                                        .elementAt(0)
                                        .toString());
                                    _selectedStaffWithId.remove(value
                                        .split('@')
                                        .elementAt(1)
                                        .toString());
                                  } else {
                                    _selectedStaff.add(value
                                        .split('@')
                                        .elementAt(0)
                                        .toString());
                                    _selectedStaffWithId.add(value
                                        .split('@')
                                        .elementAt(1)
                                        .toString());
                                  }
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 3
                      ? StepState.complete
                      : StepState.disabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  var resultSearchDocument = '';
  continued() {
    if (_currentStep == 0) {
      _submitForm(token).then((value) {
        if (value == 0) {
          //// NOT FOUND
          setState(() {
            _currentStep;
            resultSearchDocument = 'Document Not Found';
          });
        } else if (value == -1) {
          /// ERROR IN THE APP
          setState(() {
            _currentStep;
            resultSearchDocument = 'Problem occurs during search';
          });
        } else {
          //SUCCESS
          _currentStep < 3 ? setState(() => _currentStep += 1) : null;
          resultSearchDocument = '';
        }
      });
    } else {
      _currentStep < 3 ? setState(() => _currentStep += 1) : null;
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  void showSnackBarMessage(String message, [MaterialColor color = Colors.red]) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitDetails() {
    final FormState? formState = _formKey.currentState;
    if (!formState!.validate()) {
    } else {
      LoadingIndicatorDialog().show(context);
      //dbHandler.SaveRecensement(recensement);
      LoadingIndicatorDialog().dismiss();
      Navigator.of(context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const SupplyLogisticPage()));
    }
  }
}
