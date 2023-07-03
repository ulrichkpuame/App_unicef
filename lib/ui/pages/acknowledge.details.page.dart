// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, use_build_context_synchronously, depend_on_referenced_packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/history.transfer.dart';
import 'package:unicefapp/models/dto/material.details.dart';
import 'package:unicefapp/ui/pages/acknowledge.page.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';

class AcknowledgeDetailsPage extends StatefulWidget {
  const AcknowledgeDetailsPage({super.key, required this.historyTransfer});

  final HistoryTransfer historyTransfer;

  @override
  State<AcknowledgeDetailsPage> createState() => _AcknowledgeDetailsPageState();
}

class _AcknowledgeDetailsPageState extends State<AcknowledgeDetailsPage> {
  late final List<MaterialDetails?> tableData;
  List<TextEditingController> textEditingControllers = [];
  final storage = locator<TokenStorageService>();

  String transferType = '';
  String idTransfer = '';
  String documentId = '';
  String apiResult = '';
  var result = '';
  Map<String, String> requestBody = {};

  @override
  void initState() {
    transferType = widget.historyTransfer.typeOfTransfer;
    idTransfer = widget.historyTransfer.id;
    documentId = widget.historyTransfer.documentNumber;
    _getCurrentPosition();

    super.initState();
  }

  // --------- LOCATION ------------ //
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location services are disabled. Please enable the services')));
      // return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Location permissions are denied')));
        // return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location permissions are permanently denied, we cannot request permissions.')));
      // return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
      // _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
  ////------------ END LOCATION -----------///

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _submitForm() async {
    textEditingControllers.asMap().entries.map(
        (e) => {requestBody['qtyReport_' + e.key.toString()] = e.value.text});
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://www.trackiteum.org/u/admin/acknowledge/edit/$transferType/$idTransfer'),
    );
    var stream =
        http.ByteStream(DelegatingStream.typed(this.image!.openRead()));

    // get file length
    var length = await this.image!.length();

    // multipart that takes file
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: path.basename(this.image!.path));

    // add file to multipart
    request.files.add(multipartFile);
    textEditingControllers
        .asMap()
        .forEach((i, e) => request.fields['qtyReport_$i'] = e.value.text);
    request.fields['longitude'] = _currentPosition!.longitude.toString();
    request.fields['latitude'] = _currentPosition!.latitude.toString();
    print(request);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

    ///-------- POPU UP OF SUCCESS ---------//
    if (response.statusCode == 200) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text('ACKNOWLEDGE',
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
                        'Acknowledge was Successfull',
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
        ),
      );
    } else {
      setState(() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text('ACKNOWLEDGE',
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
                          'Error in Acknowledging',
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
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    textEditingControllers.map((e) => e.dispose());
    super.dispose();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  Widget build(BuildContext context) {
    var listMaterials =
        List<MaterialDetails>.from(widget.historyTransfer.materialDetails);
    List<TextEditingController> textEditingCtrl = [];
    int i = 0;
    listMaterials.forEach((str) {
      var textEditingController = TextEditingController();
      textEditingCtrl.add(textEditingController);
    });
    setState(() {
      textEditingControllers = textEditingCtrl;
    });
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
                          builder: (context) => AcknowledgePage()),
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
                'Acknowledge',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Confirm quantity and capture image',
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
            //-------------------AFFICHAGE DES DONNEE DU ACKNOWLEDGE SELECTIONNEE--------------
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 600,
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.5),
                      color: Defaults.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Waybill: ${widget.historyTransfer.documentNumber}',
                                    style: TextStyle(
                                        color: Defaults.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Matricule Vehicule: ${widget.historyTransfer.ip}',
                                    style: TextStyle(
                                        color: Defaults.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Driver Name: ${widget.historyTransfer.driver}',
                                    style: TextStyle(
                                        color: Defaults.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Driver Number: ${widget.historyTransfer.driver}',
                                    style: TextStyle(
                                        color: Defaults.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //-------------------LISTE DES MATERIALS--------------
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: DataTable(
                        dividerThickness: 5,
                        dataRowHeight: 80,
                        showBottomBorder: true,
                        headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Defaults.bluePrincipal),
                        headingRowColor: MaterialStateProperty.resolveWith(
                            (states) => Defaults.white),
                        columns: const [
                          DataColumn(label: Text('Material Name')),
                          DataColumn(label: Text('Qty Received')),
                        ],
                        rows: widget.historyTransfer.materialDetails
                            .asMap()
                            .entries
                            .map((data) {
                          return DataRow(cells: [
                            DataCell(Text(data.value.materialDescription)),
                            DataCell(
                              ListTile(
                                title: TextField(
                                  controller: textEditingCtrl[data.key],
                                  keyboardType: TextInputType.number,
                                  autofocus: true,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            ///---------------- ZONE DE BOUTTON ET D'AFFICHAGE IMAGE----------------
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ////-------- IMAGE ------///
                  Container(
                      child: StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        if (image != null)
                          Image.file(
                            image!,
                            height: 200,
                          ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final image = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);
                              if (image == null) return;
                              final imageTemp = File(image.path);
                              setState(() => this.image = imageTemp);
                            } on PlatformException catch (e) {
                              print('Failed to pick image: $e');
                            }
                          },
                          child: const Icon(
                            Icons.camera,
                            color: Defaults.white,
                          ),
                        ),
                      ],
                    );
                  })),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
