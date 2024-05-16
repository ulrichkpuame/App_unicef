// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, use_build_context_synchronously, depend_on_referenced_packages, prefer_typing_uninitialized_variables, unused_local_variable, unused_field
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/db/local.servie.dart';
import 'package:unicefapp/db/repository.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/history.transfer.dart';
import 'package:unicefapp/models/dto/issues.dart';
import 'package:unicefapp/models/dto/material.details.dart';
import 'package:unicefapp/models/dto/stock.dart';
import 'package:unicefapp/ui/pages/Acknowledge/acknowledge.page%20copy.dart';
import 'package:unicefapp/ui/pages/Acknowledge/acknowledge.page.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';
import 'package:connectivity/connectivity.dart' as connectivity;
import 'package:uuid/uuid.dart';

class AcknowledgeDetailsPageCopy extends StatefulWidget {
  const AcknowledgeDetailsPageCopy({super.key, required this.historyTransfer});

  final HistoryTransfer historyTransfer;

  @override
  State<AcknowledgeDetailsPageCopy> createState() =>
      _AcknowledgeDetailsPageCopyState();
}

class _AcknowledgeDetailsPageCopyState
    extends State<AcknowledgeDetailsPageCopy> {
  late final List<MaterialDetails?> tableData;
  List<TextEditingController> textEditingControllers = [];
  final storage = locator<TokenStorageService>();
  final dbHandler = locator<LocalService>();
  final _formKey = GlobalKey<FormState>();
  late final Repository _repository;

  String transferType = '';
  String idTransfer = '';
  String documentId = '';
  String apiResult = '';
  String? selectedCountry;
  var result = '';
  var uuid = Uuid();
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  Map<String, String> requestBody = {};
  String BASEURL = 'https://www.trackiteum.org';

  @override
  void initState() {
    transferType = widget.historyTransfer.typeOfTransfer;
    idTransfer = widget.historyTransfer.id;
    documentId = widget.historyTransfer.documentNumber;
    selectedCountry = widget.historyTransfer.country;
    _getCurrentPosition();
    checkInternetConnectivity();

    super.initState();
  }

  // Function pour vérifier la connexion internet
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult =
        await (connectivity.Connectivity().checkConnectivity());
    return connectivityResult == connectivity.ConnectivityResult.mobile ||
        connectivityResult == connectivity.ConnectivityResult.wifi;
  }

  // --------- LOCATION ------------ //
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {}
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {}
    }
    if (permission == LocationPermission.deniedForever) {}
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

  void _saveAcknowOffline() async {
    try {
      String acknowId = widget.historyTransfer.id;
      List<MaterialDetails> updatedMaterialDetails = [];

      for (int i = 0; i < textEditingControllers.length; i++) {
        String materialQtyReceived = textEditingControllers[i].text;
        MaterialDetails materialDetails =
            widget.historyTransfer.materialDetails[i];
        MaterialDetails updatedMaterial = MaterialDetails(
          materialDescription: materialDetails.materialDescription,

          materialQuantityReceived: materialQtyReceived,
          // materialQuantityReceived: int.parse(materialQuantityReceived),

          materialName: materialDetails.materialName,
          materialQuantity: materialDetails.materialQuantity,
        );
        updatedMaterialDetails.add(updatedMaterial);
      }

      HistoryTransfer updatedHistoryTransfer = HistoryTransfer(
        id: acknowId,
        country: widget.historyTransfer.country,
        initiatingDate: widget.historyTransfer.initiatingDate,
        typeOfTransfer: widget.historyTransfer.typeOfTransfer,
        documentNumber: widget.historyTransfer.documentNumber,
        ip: widget.historyTransfer.ip,
        ipName: widget.historyTransfer.ip,
        driverCompany: widget.historyTransfer.driverCompany,
        matricule: widget.historyTransfer.matricule,
        driver: widget.historyTransfer.driver,
        driverNumber: widget.historyTransfer.driverNumber,
        ipReceiver: widget.historyTransfer.ipReceiver,
        status: widget.historyTransfer.status,
        dateOfReception: formattedDate,
        //
        materialDetails: updatedMaterialDetails,
        //
        comments: widget.historyTransfer.comments,
        zrostDdelIDs: widget.historyTransfer.zrostDdelIDs,
      );

      await dbHandler.SaveAcknow(updatedHistoryTransfer);

      ///-------- POPU UP OF SUCCESS ---------//
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
                  AppLocalizations.of(context)!.acknowSuccessMsg,
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
    } catch (e) {
      LoadingIndicatorDialog().dismiss();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.error,
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/error-dialog.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 120,
                  ),
                  Text(
                    AppLocalizations.of(context)!.acknowErrorMsg,
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
        },
      );
    }
  }

  void _saveAcknowOnline() async {
    if (image != null && _currentPosition != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$BASEURL/u/admin/acknowledge/$transferType/$idTransfer/$selectedCountry'),
      );
      var stream = http.ByteStream(DelegatingStream.typed(image!.openRead()));

      // get file length
      var length = await image!.length();

      // multipart that takes file
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: path.basename(image!.path));

      // add file to multipart
      request.files.add(multipartFile);
      textEditingControllers.asMap().forEach((i, e) {
        request.fields['qtyReport_$i'] = e.value.text;
        print('qtyReport_$i : ${request.fields['qtyReport_$i']}');
      });

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
                    AppLocalizations.of(context)!.acknowSuccessMsg,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
                child: Text(AppLocalizations.of(context)!.goBack),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
                    AppLocalizations.of(context)!.acknowErrorMsg,
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
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        );
      }
    } else {
      print('Image or current position is null');
      // Handle the case where image or current position is null
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
    for (var str in listMaterials) {
      var textEditingController = TextEditingController();
      textEditingCtrl.add(textEditingController);
    }
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
                          builder: (context) => AcknowledgePageCopy()),
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
              Text(
                AppLocalizations.of(context)!.acknowledgeSubTitle,
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
              child: SizedBox(
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
                                    // 'Waybill: ${widget.historyTransfer.documentNumber}',
                                    '${AppLocalizations.of(context)!.waybill} ${widget.historyTransfer.documentNumber}',
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
                                    '${AppLocalizations.of(context)!.matriculeVehicule} ${widget.historyTransfer.matricule}',
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
                                    '${AppLocalizations.of(context)!.driverName} ${widget.historyTransfer.driver}',
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
                                    '${AppLocalizations.of(context)!.driverNumber} ${widget.historyTransfer.driverNumber}',
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
                        columns: [
                          DataColumn(
                              label: Text(
                                  AppLocalizations.of(context)!.materialName)),
                          DataColumn(
                              label: Text(
                                  AppLocalizations.of(context)!.qtyReceived)),
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

                  ////-------- BOUTON DE SAUVEGARDE OU D'ENVOI ------///
                  ElevatedButton(
                    onPressed: () async {
                      bool isConnected = await checkInternetConnectivity();

                      if (isConnected) {
                        _saveAcknowOnline();
                      } else {
                        _saveAcknowOffline();
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.submit),
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
