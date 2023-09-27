// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/models/dto/issues.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class PMVPage extends StatefulWidget {
  const PMVPage({super.key});

  @override
  State<PMVPage> createState() => _PMVPageState();
}

class _PMVPageState extends State<PMVPage> {
  //--------------------------- DECLARATION POUR LES AUTRES STEPPER --------------------////
  //---------- STEPPER ONE --------- //
  TextEditingController officeController = TextEditingController();
  TextEditingController activityDetailsController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController teamController = TextEditingController();
  TextEditingController visitController = TextEditingController();

  //---------- STEPPER TWO --------- //
  TextEditingController _question1 = TextEditingController();
  TextEditingController _question2 = TextEditingController();
  TextEditingController _question4 = TextEditingController();
  TextEditingController _question5 = TextEditingController();
  TextEditingController _question6 = TextEditingController();
  TextEditingController _question7 = TextEditingController();
  TextEditingController _question8 = TextEditingController();
  TextEditingController _question10 = TextEditingController();

  //---------- STEPPER THREE --------- //
  TextEditingController _question11 = TextEditingController();
  TextEditingController _question14 = TextEditingController();
  TextEditingController _question15 = TextEditingController();
  TextEditingController _question17 = TextEditingController();
  TextEditingController _question18 = TextEditingController();
  TextEditingController _question20 = TextEditingController();

  //---------- STEPPER FOUR --------- //
  TextEditingController _question24 = TextEditingController();
  TextEditingController _question27 = TextEditingController();
  TextEditingController _question29 = TextEditingController();
  TextEditingController _question30 = TextEditingController();

  //---------- STEPPER FIVE --------- //
  TextEditingController _question31 = TextEditingController();
  TextEditingController _question32 = TextEditingController();
  TextEditingController _question33 = TextEditingController();
  TextEditingController _question34 = TextEditingController();
  TextEditingController _question35 = TextEditingController();
  TextEditingController _question36 = TextEditingController();
  TextEditingController _question37 = TextEditingController();
  TextEditingController _question38 = TextEditingController();
  TextEditingController _question39 = TextEditingController();
  TextEditingController _question40 = TextEditingController();

  //-------------------------- DECLARATION POUR YES/NO ------------------------////
  //---------- STEPPER TWO --------- //
  late TextEditingController _question3;
  late TextEditingController _question4Bis;
  late TextEditingController _question5Bis;
  late TextEditingController _question6Bis;
  late TextEditingController _question7Bis;
  late TextEditingController _question8Bis;
  late TextEditingController _question9;
  late TextEditingController _question10Bis;

  //---------- STEPPER THREE --------- //
  late TextEditingController _question11Bis;
  late TextEditingController _question12;
  late TextEditingController _question13;
  late TextEditingController _question16;
  late TextEditingController _question19;

  //---------- STEPPER FOUR --------- //
  late TextEditingController _question21;
  late TextEditingController _question22;
  late TextEditingController _question23;
  late TextEditingController _question24Bis;
  late TextEditingController _question25;
  late TextEditingController _question26;
  late TextEditingController _question27Bis;
  late TextEditingController _question28;
  late TextEditingController _question29Bis;
  late TextEditingController _question30Bis;

  //---------- STEPPER FIVE --------- //
  late TextEditingController _question31Bis;
  late TextEditingController _question32Bis;
  late TextEditingController _question33Bis;
  late TextEditingController _question39Bis;
  late TextEditingController _question40Bis;

  String apiResult = '';
  int? selectedValue;
  List<Issue> tableData = [];
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  TextEditingController _selectedValue = TextEditingController();
  List<String> listOfValue = [
    '1. Primary Field Monitor is Staff ',
    '2. Third Party Monitor',
  ];

  TextEditingController _selectedPartner = TextEditingController();
  List<String> listOfPartner = [
    'Ministerio da Saude',
    'NUCLEO DE NUTRICAO',
    'Comite Abandono  Praticas Nefastas',
    'Associacao dos amigos da crianca',
    'INSTITUTO DA MULHER E CRIANCA',
    'Policia Judiciaria-Brig. menores',
    'Direccao Regional de Saude-SAB',
    'MINISTERIO DA EDUCACAO NACIONAL',
    'MINISTERIO DA JUSTICA',
    'UNICEF BISSAU',
    'DIRECCAO GERAL RECURSOS HIDRICOS',
  ];

  TextEditingController _selectedSection = TextEditingController();
  List<String> listOfSection = [
    'Operation',
    'Program',
  ];

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime? _selectedDate1;
  DateTime? _selectedDate2;

  final controllerStartDateTime = TextEditingController();
  final controllerEndDateTime = TextEditingController();

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate1) {
      setState(() {
        _selectedDate1 = picked;
        controllerStartDateTime.text =
            DateFormat('yyyy-MM-dd').format(_selectedDate1!);
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate2) {
      setState(() {
        _selectedDate2 = picked;
        controllerEndDateTime.text =
            DateFormat('yyyy-MM-dd').format(_selectedDate2!);
      });
    }
  }

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

  void _submitPMV() async {
    // Effectuer l'appel à l'API pour récupérer les données du tableau

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.trackiteum.org/u/admin/pmv'));

    var stream =
        // ignore: deprecated_member_use
        http.ByteStream(DelegatingStream.typed(image!.openRead()));

    // get file length
    var length = await image!.length();

    // multipart that takes file
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: path.basename(image!.path));

    // add file to multipart
    request.files.add(multipartFile);

    request.fields["officeController"] = officeController.text;

    request.fields["activityDetailsController"] =
        activityDetailsController.text;

    request.fields["locationController"] = locationController.text;

    request.fields["siteController"] = siteController.text;

    request.fields["sectionController"] = sectionController.text;

    request.fields["teamController"] = teamController.text;

    request.fields["visitController"] = visitController.text;

    request.fields["monitor_information"] = _selectedValue.text;

    request.fields["partner"] = _selectedPartner.text;

    request.fields["section"] = _selectedSection.text;

    request.fields["start_date"] = controllerStartDateTime.text;

    request.fields["end_date"] = controllerEndDateTime.text;

    request.fields["question1"] = _question1.text;

    request.fields["question2"] = _question2.text;

    request.fields["question4"] = _question4.text;

    request.fields["question5"] = _question5.text;

    request.fields["question6"] = _question6.text;

    request.fields["question7"] = _question7.text;

    request.fields["question8"] = _question8.text;

    request.fields["question10"] = _question10.text;

    request.fields["question11"] = _question11.text;

    request.fields["question14"] = _question14.text;

    request.fields["question15"] = _question15.text;

    request.fields["question17"] = _question17.text;

    request.fields["question18"] = _question18.text;

    request.fields["question20"] = _question20.text;

    request.fields["question24"] = _question24.text;

    request.fields["question27"] = _question27.text;

    request.fields["question29"] = _question29.text;

    request.fields["question30"] = _question30.text;

    request.fields["question31"] = _question31.text;

    request.fields["question32"] = _question32.text;

    request.fields["question33"] = _question33.text;

    request.fields["question34"] = _question34.text;

    request.fields["question35"] = _question35.text;

    request.fields["question36"] = _question36.text;

    request.fields["question37"] = _question37.text;

    request.fields["question38"] = _question38.text;

    request.fields["question39"] = _question39.text;

    request.fields["question40"] = _question40.text;

    request.fields["question3"] = _question3.text;

    request.fields["question4Bis"] = _question4Bis.text;

    request.fields["question5Bis"] = _question5Bis.text;

    request.fields["question6Bis"] = _question6Bis.text;

    request.fields["question7Bis"] = _question7Bis.text;

    request.fields["question8Bis"] = _question8Bis.text;

    request.fields["question9"] = _question9.text;

    request.fields["question10Bis"] = _question10Bis.text;

    request.fields["question11Bis"] = _question11Bis.text;

    request.fields["question12"] = _question12.text;

    request.fields["question13"] = _question13.text;

    request.fields["question16"] = _question16.text;

    request.fields["question19"] = _question19.text;

    request.fields["question21"] = _question21.text;

    request.fields["question22"] = _question22.text;

    //request.fields["question23"] = '';

    request.fields["question23"] = _question23.text;

    request.fields["question24Bis"] = _question24Bis.text;

    request.fields["question25"] = _question25.text;

    request.fields["question26"] = _question26.text;

    request.fields["question27Bis"] = _question27Bis.text;

    request.fields["question28"] = _question28.text;

    request.fields["question29Bis"] = _question29Bis.text;

    request.fields["question30Bis"] = _question30Bis.text;

    request.fields["question31Bis"] = _question31Bis.text;

    request.fields["question32Bis"] = _question32Bis.text;

    request.fields["question33Bis"] = _question33Bis.text;

    request.fields["question39Bis"] = _question39Bis.text;

    request.fields["question40Bis"] = _question40Bis.text;

    // send

    var response = await request.send();

    print(response.statusCode);

    // listen for response

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

    ///-------- POPU UP OF SUCCESS ---------//
    ///
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
                  'PMV was Successfull',
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
                  'Unuccessfull PMV',
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
  void initState() {
    super.initState();
    _question3 = TextEditingController();
    _question4Bis = TextEditingController();
    _question5Bis = TextEditingController();
    _question6Bis = TextEditingController();
    _question7Bis = TextEditingController();
    _question8Bis = TextEditingController();
    _question9 = TextEditingController();
    _question10Bis = TextEditingController();
    _question11Bis = TextEditingController();
    _question12 = TextEditingController();
    _question13 = TextEditingController();
    _question16 = TextEditingController();
    _question19 = TextEditingController();
    _question21 = TextEditingController();
    _question22 = TextEditingController();
    _question23 = TextEditingController();
    _question24Bis = TextEditingController();
    _question25 = TextEditingController();
    _question26 = TextEditingController();
    _question27Bis = TextEditingController();
    _question28 = TextEditingController();
    _question29Bis = TextEditingController();
    _question30Bis = TextEditingController();
    _question31Bis = TextEditingController();
    _question32Bis = TextEditingController();
    _question33Bis = TextEditingController();
    _question39Bis = TextEditingController();
    _question40Bis = TextEditingController();
  }

  @override
  void dispose() {
    officeController.dispose();
    activityDetailsController.dispose();
    locationController.dispose();
    siteController.dispose();
    sectionController.dispose();
    teamController.dispose();
    visitController.dispose();
    _question1.dispose();
    _question2.dispose();
    _question4.dispose();
    _question5.dispose();
    _question6.dispose();
    _question7.dispose();
    _question8.dispose();
    _question10.dispose();
    _question11.dispose();
    _question14.dispose();
    _question15.dispose();
    _question17.dispose();
    _question18.dispose();
    _question20.dispose();
    _question24.dispose();
    _question27.dispose();
    _question29.dispose();
    _question30.dispose();
    _question31.dispose();
    _question32.dispose();
    _question33.dispose();
    _question34.dispose();
    _question35.dispose();
    _question36.dispose();
    _question37.dispose();
    _question38.dispose();
    _question39.dispose();
    _question40.dispose();
    _question3.dispose();
    _question4Bis.dispose();
    _question5Bis.dispose();
    _question6Bis.dispose();
    _question7Bis.dispose();
    _question8Bis.dispose();
    _question9.dispose();
    _question10Bis.dispose();
    _question11Bis.dispose();
    _question12.dispose();
    _question13.dispose();
    _question16.dispose();
    _question19.dispose();
    _question21.dispose();
    _question22.dispose();
    _question23.dispose();
    _question24Bis.dispose();
    _question25.dispose();
    _question26.dispose();
    _question27Bis.dispose();
    _question28.dispose();
    _question29Bis.dispose();
    _question30Bis.dispose();
    _question31Bis.dispose();
    _question32Bis.dispose();
    _question33Bis.dispose();
    _question39Bis.dispose();
    _question40Bis.dispose();

    super.dispose();
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
                'PVM',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Performance Monitoring Visit',
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
        child: Container(
          child: Form(
            key: _formKey,
            child: Theme(
              data: ThemeData(primarySwatch: Defaults.primaryBleuColor),
              child: Stepper(
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep == 0) ...[
                        ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: const Text('Next',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white))),
                      ] else if (_currentStep == 4) ...[
                        ElevatedButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Previous',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white))),
                        ElevatedButton(
                            onPressed: () {
                              _submitPMV();
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
                physics: const ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                onStepCancel: cancel,
                steps: <Step>[
                  //-------- STEPPER ONE --------//
                  Step(
                    title: const Text('Create the case',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        // --------------- CHAMP DE SAISIE 1 ---------- //
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Activity Details')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, activityDetailsController),
                        const SizedBox(
                          height: 8,
                        ),

                        // --------------- CHAMP DE SAISIE 2 ---------- //
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Location to be visited')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, locationController),
                        const SizedBox(
                          height: 8,
                        ),

                        // --------------- CHAMP DE SAISIE 3 ---------- //
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Site To Be Visited')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, siteController),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Starting on')),
                        const SizedBox(
                          height: 4,
                        ),

                        TextFormField(
                          controller: controllerStartDateTime,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.calendar_month),
                            filled: true,
                            fillColor: Defaults.white,
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Defaults.white), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Defaults.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _selectDate1(context);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a date';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Ending on')),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: controllerEndDateTime,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.calendar_month),
                            filled: true,
                            fillColor: Defaults.white,
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Defaults.white), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Defaults.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // decoration: InputDecoration(
                          //   labelText: 'End Date',
                          // ),
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _selectDate2(context);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        // --------------- CHAMP DE SAISIE 4 ---------- //
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Sections')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, sectionController),
                        const SizedBox(
                          height: 8,
                        ),
                        const SizedBox(
                          height: 8,
                        ),

                        // --------------- CHAMP DE SAISIE 5 ---------- //
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Office')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, officeController),
                        const SizedBox(
                          height: 8,
                        ),
                        DropdownButtonFormField(
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
                          value: _selectedValue.text.isNotEmpty
                              ? _selectedValue.text
                              : null,
                          hint: const Text(
                            'Select from the list',
                          ),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue.text = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "can't empty";
                            } else {
                              return null;
                            }
                          },
                          items: listOfValue.map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),

                        // --------------- CHAMP DE SAISIE 6 ---------- //
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Team Member')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, teamController),
                        const SizedBox(
                          height: 8,
                        ),

                        // --------------- CHAMP DE SAISIE 7 ---------- //
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Visit Lead')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, visitController),
                        const SizedBox(
                          height: 8,
                        ),

                        // --------------- CHAMP DE SAISIE 8 ---------- //
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Entities to monitor')),
                        const SizedBox(
                          height: 4,
                        ),
                        DropdownButtonFormField(
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
                          value: _selectedPartner.text.isNotEmpty
                              ? _selectedPartner.text
                              : null,
                          hint: const Text('Select from the partners list'),
                          isExpanded: true,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPartner.text = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "can't empty";
                            } else {
                              return null;
                            }
                          },
                          items: listOfPartner.map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),

                        // --------------- CHAMP DE SAISIE 9 ---------- //
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('CP Monitors')),
                        const SizedBox(
                          height: 4,
                        ),
                        DropdownButtonFormField(
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
                          value: _selectedSection.text.isNotEmpty
                              ? _selectedSection.text
                              : null,
                          hint: const Text(
                            'Select from the list of Sections',
                          ),
                          isExpanded: true,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSection.text = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "can't empty";
                            } else {
                              return null;
                            }
                          },
                          items: listOfSection.map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),

                  //-------- STEPPER TWO --------//
                  Step(
                    title: const Text('Checklist once on site part one',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '1.	Proportion of beneficiaries in the programme location that can explain at least one channel to report SEA (such as SMS, phone hotline, email, feedback box, PSEA focal point from partner organization) ')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question1),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '2.	Proportion of partner personnel (staff, consultants, volunteers, interns, sub-contractors) in the location who have received a training on PSEA In the last 12 months that meets the minimum criteria?  ')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question2),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '3.	Do UNICEF-supported sites of the partner have visible communications materials (posters, leaflets, brochures) on how to report allegations of sexual exploitation and abuse? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 1,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question3.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 2,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question3.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        //RadioButton(context, _question3),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '4.	Is there any indication of continuity in use of services / sustainable adoption of practice?  ')),
                        const SizedBox(
                          height: 4,
                        ),
                        //RadioButtonsWidget(),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 3,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question4Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 4,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question4Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question4),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '5.	Are primary intended users satisfied with services/programme interventions? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 5,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question5Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 6,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question5Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question5),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '6.	Is there any indication of cost-barriers preventing access to services or adoption of behaviours? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 7,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question6Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 8,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question6Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question6),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '7.	Is there any indication of socio-cultural practices/beliefs influencing access/use/adoption (especially by vulnerable sub-groups)? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 9,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question7Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 10,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question7Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question7),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '8.	Is there indication of gaps in availability of essential supplies for services (not provided by UNICEF)? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 11,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question8Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 12,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question8Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question8),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '9.	Is there indication of supplies provided through the partnership being used? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 13,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question9.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 14,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question9.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '10.	Do key supplies provided through the partnership meet agreed quality standards? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 15,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question10Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 16,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question10Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question10),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),

                  //-------- STEPPER THREE --------//
                  Step(
                    title: const Text('Checklist once on site part two',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '11.	Was the distribution of key supplies seen to be fair and effective?  ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 17,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question11Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 18,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question11Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question11),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '12.	Were key supplies provided through the partnership on time')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 19,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question12.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 20,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question12.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '13.	Are key supplies provided through the partnership available in safe, secure and usable condition? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 21,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question13.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 22,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question13.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '14.	List any observations resulting from the visit and any action items agreed with the implementing partner. ')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question14),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '15.	List the activities monitored and verified during the programmatic visit ')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question15),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '16.	Have the activities been implemented as planned and reported by the implementing partner? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 23,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question16.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 24,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question16.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '17.	List any feedback from the communities and children on the programme and services provided ')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question17),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '18.	Is there an effective community feedback mechanism in place? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question18),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '19.	Is there engagement with existing community structures/mechanisms/capacities? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 25,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question19.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 26,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question19.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '20.	Are partners adequately providing critical information on lifesaving/protection practices')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question20),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  ),

                  //-------- STEPPER FOUR --------//
                  Step(
                    title: const Text('Checklist once on site part three',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '21.	Do stakeholders have any experience or observation of SEA behaviours during the programme implementation? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 27,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question21.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 28,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question21.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '22.	Was the experience or observation reported? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 29,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question22.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 30,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question22.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '23.	Do children and adults have access to a safe accessible channel to report sexual exploitation and abuse? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 31,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question23.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 32,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question23.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '24.	Are there any issues with policies/procedures which are hampering services/programmes? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 33,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question24Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 34,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question24Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question24),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '25.	Are budget disbursements to services/programmes timely? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 35,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question25.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 36,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question25.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '26.	Are budget disbursements to services/programmes as planned/allocated? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 37,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question26.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 38,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question26.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '27.	Is there sufficient availability/adequacy of key staff (number at specific levels) relevant to the service points visited? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 39,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question27Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 40,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question27Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question27),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '28.	Are there gaps/challenges in coordination across services? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 41,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question28.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 42,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question28.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '29.	Is there evidence of any gaps in support to services/programmes? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 43,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question29Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 44,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question29Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question29),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '30.	Is there any evidence of unintended negative effects of programmes/services? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 45,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question30Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 46,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question30Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question30),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 3
                        ? StepState.complete
                        : StepState.disabled,
                  ),

                  //-------- STEPPER FIVE --------//
                  Step(
                    title: const Text('Checklist once on site part five',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '31.	Does programme implementation adhere to key programmatic standards for quality and completeness? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 47,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question31Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 48,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question31Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question31),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '32.	Is there any evidence of exclusion or marginalisation of specific groups, including children on the move, from services or information? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 49,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question32Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 50,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question32Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question32),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '33.	Is there any evidence of exclusion or marginalisation of children with disabilities from services or information? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 51,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question33Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 52,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question33Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question33),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '34.	How many children and adults can be reasonably estimated to indirectly benefit from UNICEF-support at this location? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question34),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '35.	How many girls can be reasonably estimated to directly benefit from UNICEF-support at this location? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question35),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '36.	How many children can be reasonably estimated to directly benefit from UNICEF-support at this location?')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question36),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('37. Addition follow up actions  ')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question37),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('38.	Additional information')),
                        const SizedBox(
                          height: 4,
                        ),
                        ZoneSaisie(context, _question38),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('39.	Attachment / Pictures on site ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 53,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question39Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 54,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question39Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question39),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '40.	Is there any evidence of unintended negative effects of programmes/services? ')),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 55,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question40Bis.text = 'Yes';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('Yes'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 56,
                                              groupValue: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value;
                                                  _question40Bis.text = 'No';
                                                });
                                              },
                                            ),
                                            const Expanded(
                                              child: Text('No'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ZoneSaisie(context, _question40),
                        const SizedBox(
                          height: 8,
                        ),
                        ////-------- IMAGE ------///
                        Container(child:
                            StatefulBuilder(builder: (context, setState) {
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
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 4
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep == 0) {
      //_submitForm(token);
    }
    _currentStep < 5 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
