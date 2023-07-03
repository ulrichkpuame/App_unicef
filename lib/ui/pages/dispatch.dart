import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/models/dto/inventory.dart';
import 'package:http/http.dart' as http;
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';
import 'dart:convert';

import 'package:unicefapp/widgets/mydrawer.dart';

class DispatchPage extends StatefulWidget {
  @override
  _DispatchPageState createState() => _DispatchPageState();
}

class _DispatchPageState extends State<DispatchPage> {
  final _formKey = GlobalKey<FormState>();
  List<Inventory> tableData = [];

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  // void fetchData() async {
  //   // Effectuer l'appel à l'API pour récupérer les données du tableau
  //   var response =
  //       await http.get(Uri.parse('https://votre-api.com/table-data'));

  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body);
  //     List<Inventory> data = [];

  //     for (var item in jsonResponse) {
  //       var apiResponse = Inventory.fromJson(item);
  //       data.add(apiResponse);
  //     }

  //     setState(() {
  //       tableData = data;
  //     });
  //   }
  // }

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
          title: const Column(
            children: [
              Text(
                'DISPATCH',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Dispatch Products',
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    left: 23, top: 8.0, right: 8.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'RECEIVER INFORMATION',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // controller: zrostController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Defaults.white,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1, color: Defaults.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Defaults.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Enter Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Full Name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // controller: zrostController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Defaults.white,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1, color: Defaults.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Defaults.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Enter Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // controller: zrostController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Defaults.white,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1, color: Defaults.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Defaults.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Enter Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Phone Number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 5,
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
              const Padding(
                padding: EdgeInsets.only(
                    left: 23, top: 8.0, right: 8.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'MATERIAL INFORMATION',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
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
                  // value: zrost_ddelController.text.isNotEmpty
                  //     ? zrost_ddelController.text
                  //     : null,
                  hint: const Text('Material'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select zrost or ddel';
                    }
                    return null;
                  },
                  items: [],
                  // items: zrost_ddelControllerValue.map((String option) {
                  //   return DropdownMenuItem<String>(
                  //     value: option,
                  //     child: Text(option),
                  //   );
                  // }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      // zrost_ddelController.text = newValue!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // controller: zrostController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Defaults.white,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1, color: Defaults.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Defaults.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Enter Batch Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Batch Number';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // controller: zrostController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Defaults.white,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1, color: Defaults.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Defaults.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Enter Quantity',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Quantity';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: previewDispatch,
                    child: const Text('Preview',
                        style: TextStyle(fontSize: 15, color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBarMessage(String message,
      [MaterialColor color = Colors.red]) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void previewDispatch() async {
    final FormState? formState = _formKey.currentState;
    // if (formState!.validate()) {
    //   showSnackBarMessage('Renseigner les champs obligatoires');
    // } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'DISPATCH PREVIEW',
              style: TextStyle(
                color: Defaults.black,
              ),
            ),
            content: Container(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receiver Information',
                    style:
                        TextStyle(color: Defaults.bluePrincipal, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: '),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Email: '),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Phone Number: '),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Material Information',
                    style:
                        TextStyle(color: Defaults.bluePrincipal, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Material: '),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Batch Number: '),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Quantity: '),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    //dispatchSuccess();
                    Navigator.of(context).pop();
                  },
                  child: Text('Submit')),
            ],
          );
        });
    // }
  }

  void dispatchSuccess() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text('DISPATCH',
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
                        'Dispatch was Successfull',
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
        );
      },
    );
  }
}
