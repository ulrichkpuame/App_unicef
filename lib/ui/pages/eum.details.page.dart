// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_local_variable, use_build_context_synchronously

import 'dart:io';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/appsurveyextraction.dart';
import 'package:unicefapp/models/dto/organisation.dart';
import 'package:unicefapp/models/dto/surveyExtraction.dart';
import 'package:unicefapp/models/dto/surveyPage.dart';
import 'package:unicefapp/ui/pages/EUM/Questionario.de.observa%C3%A7ao.details.dart';
import 'package:unicefapp/ui/pages/eum.page.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:unicefapp/widgets/loading.indicator.dart';
import 'package:async/async.dart';

class EUMDetailsPage extends StatefulWidget {
  const EUMDetailsPage({super.key, required this.dtoSurveyExtration});

  final DTOSurveyExtration dtoSurveyExtration;

  @override
  State<EUMDetailsPage> createState() => _EUMDetailsPageState();
}

class _EUMDetailsPageState extends State<EUMDetailsPage> {
  TextEditingController zoneSaisieController = TextEditingController();
  late Future<AppSurveyExtraction> tableData;
  // AppSurveyExtraction? tableData2;
  List<TextEditingController> textEditingControllers = [];
  final Map<String, TextEditingController> textEditingControllers2 = HashMap();
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;
  String apiResult = '';
  String userid = '';

  late TextEditingController radioButtonController;
  int? selectedValue;

  int i = 0;

  @override
  void initState() {
    super.initState();
    getAgent().then((value) => userid = value!.id);
    tableData = _getEUMdetails(widget.dtoSurveyExtration.survey_id);

    tableData.then((value) {
      value.survey!.page.forEach((page) {
        page.questions.forEach((e) {
          var textEditingController = TextEditingController();
          textEditingControllers.add(textEditingController);
          textEditingControllers2['${page.page_id.toString()}_${e.index}'] =
              textEditingController;
        });
      });
    });
  }

//----------- SELECT MANY IMAGE FROM GALLERY --------------//
  List<XFile>? _selectedImages;
  Future<void> _selectImages() async {
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _selectedImages = selectedImages;
      });
    }
  }

//----------- SELECT IMAGE FROM CAMERA --------------//
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

//----------- CHARGE LES INFORMATIONS DE SURVEY --------------//
  Future<AppSurveyExtraction> _getEUMdetails(String surveyId) async {
    var response = await http.get(
        Uri.parse('https://www.trackiteum.org/u/admin/survey/run/$surveyId'),
        headers: {
          "Content-type": "application/json",
        });
    if (response.statusCode == 200) {
      AppSurveyExtraction res =
          AppSurveyExtraction.fromJson(json.decode(response.body));
      return res;
    } else {
      throw Exception('Failed to load EUM');
    }
  }

// ---------- ID AGENT CONNECTED ---------------//
  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  //----------------- API SUBMIT ET FENETRE POP-UP DE SUCCESS-----------------//
  void _submitEUM() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://www.trackiteum.org/u/admin/eum/${widget.dtoSurveyExtration.survey_id}/$userid'),
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
    textEditingControllers2.forEach((k, v) => request.fields[k] = v.value.text);
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
                  'EUM was Successfull',
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
                  'animations/error-dialog.json',
                  repeat: true,
                  reverse: true,
                  fit: BoxFit.cover,
                  height: 100,
                ),
                const Text(
                  'Unuccessfull EUM',
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
                      MaterialPageRoute(builder: (context) => EUMPage()),
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
                'EUM Details',
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
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //-------------------CORPS D'AFFICHAGE--------------
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<AppSurveyExtraction>(
                    future: tableData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          children: List.generate(
                              snapshot.data!.survey!.page.length, (pindex) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      snapshot.data!.survey!.page
                                          .elementAt(pindex)
                                          .page_name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: List.generate(
                                      snapshot.data!.survey!.page
                                          .elementAt(pindex)
                                          .questions
                                          .length, (index) {
                                    if (snapshot.data!.survey!.page
                                            .elementAt(pindex)
                                            .questions
                                            .elementAt(index)
                                            .type
                                            .toString() ==
                                        'QCM') {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  snapshot.data!.survey!.page
                                                      .elementAt(pindex)
                                                      .questions
                                                      .elementAt(index)
                                                      .text
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value:
                                                            5, // La valeur correspondante à "Yes"
                                                        groupValue:
                                                            selectedValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedValue =
                                                                value;
                                                            textEditingControllers2[
                                                                    '${snapshot.data!.survey!.page.elementAt(pindex).page_id}_${snapshot.data!.survey!.page.elementAt(pindex).questions.elementAt(index).index}']!
                                                                .text = 'Yes';
                                                          });
                                                        },
                                                      ),
                                                      Text('Yes'),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value:
                                                            6, // La valeur correspondante à "No"
                                                        groupValue:
                                                            selectedValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedValue =
                                                                value;
                                                            textEditingControllers2[
                                                                    '${snapshot.data!.survey!.page.elementAt(pindex).page_id}_${snapshot.data!.survey!.page.elementAt(pindex).questions.elementAt(index).index}']!
                                                                .text = 'No';
                                                          });
                                                        },
                                                      ),
                                                      Text('No'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.data!.survey!.page
                                            .elementAt(pindex)
                                            .questions
                                            .elementAt(index)
                                            .type
                                            .toString() ==
                                        'Case a Cocher') {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                                snapshot.data!.survey!.page
                                                    .elementAt(pindex)
                                                    .questions
                                                    .elementAt(index)
                                                    .text
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value:
                                                            5, // La valeur correspondante à "Yes"
                                                        groupValue:
                                                            selectedValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedValue =
                                                                value;
                                                            final controller =
                                                                textEditingControllers
                                                                    .elementAt(
                                                                        index);
                                                            if (value == 5 ||
                                                                value == 6) {
                                                              controller.text =
                                                                  ''; // Définissez le texte du champ à une chaîne vide lorsque "Yes" ou "No" est sélectionné.
                                                            }
                                                            // textEditingControllers2[
                                                            //         '${snapshot.data!.survey!.page.elementAt(pindex).page_id}_${snapshot.data!.survey!.page.elementAt(pindex).questions.elementAt(index).index}']!
                                                            //     .text = 'Yes';
                                                          });
                                                        },
                                                      ),
                                                      Text('Yes'),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value:
                                                            6, // La valeur correspondante à "No"
                                                        groupValue:
                                                            selectedValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedValue =
                                                                value;
                                                            final controller =
                                                                textEditingControllers
                                                                    .elementAt(
                                                                        index);
                                                            if (value == 5 ||
                                                                value == 6) {
                                                              controller.text =
                                                                  ''; // Définissez le texte du champ à une chaîne vide lorsque "Yes" ou "No" est sélectionné.
                                                            }
                                                            // textEditingControllers2[
                                                            //         '${snapshot.data!.survey!.page.elementAt(pindex).page_id}_${snapshot.data!.survey!.page.elementAt(pindex).questions.elementAt(index).index}']!
                                                            //     .text = 'No';
                                                          });
                                                        },
                                                      ),
                                                      Text('No'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.data!.survey!.page
                                            .elementAt(pindex)
                                            .questions
                                            .elementAt(index)
                                            .type
                                            .toString() ==
                                        'Zone de saisie') {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  snapshot.data!.survey!.page
                                                      .elementAt(pindex)
                                                      .questions
                                                      .elementAt(index)
                                                      .text
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            ZoneSaisie(
                                                context,
                                                textEditingControllers
                                                    .elementAt(index)),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.data!.survey!.page
                                            .elementAt(pindex)
                                            .questions
                                            .elementAt(index)
                                            .type
                                            .toString() ==
                                        'Liste IP') {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  snapshot.data!.survey!.page
                                                      .elementAt(pindex)
                                                      .questions
                                                      .elementAt(index)
                                                      .text
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            DropdownButtonFormField<String>(
                                                decoration: InputDecoration(
                                                  fillColor: Defaults.white,
                                                  filled: true,
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Defaults.white,
                                                            width: 2),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Defaults.white,
                                                            width: 2),
                                                  ),
                                                ),
                                                hint: Text("Select . . ."),
                                                items: snapshot.data!.ips
                                                    .map((ev) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: ev.name,
                                                      child: Text(
                                                        ev.name,
                                                      ));
                                                }).toList(),
                                                onChanged: (value) => {}),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.data!.survey!.page
                                            .elementAt(pindex)
                                            .questions
                                            .elementAt(index)
                                            .type
                                            .toString() ==
                                        'Liste Region') {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  snapshot.data!.survey!.page
                                                      .elementAt(pindex)
                                                      .questions
                                                      .elementAt(index)
                                                      .text
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            DropdownButtonFormField<String>(
                                                hint: Text("Select . . ."),
                                                decoration: InputDecoration(
                                                  fillColor: Defaults.white,
                                                  filled: true,
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Defaults.white,
                                                            width: 2),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Defaults.white,
                                                            width: 2),
                                                  ),
                                                ),
                                                items: snapshot.data!.regions
                                                    .map((r) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: r, child: Text(r));
                                                }).toList(),
                                                onChanged: (value) => {}),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.data!.survey!.page
                                            .elementAt(pindex)
                                            .questions
                                            .elementAt(index)
                                            .type
                                            .toString() ==
                                        'Liste deroulante') {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  snapshot.data!.survey!.page
                                                      .elementAt(pindex)
                                                      .questions
                                                      .elementAt(index)
                                                      .text
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            DropdownButtonFormField<String>(
                                                hint: Text("Select . . ."),
                                                decoration: InputDecoration(
                                                  fillColor: Defaults.white,
                                                  filled: true,
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Defaults.white,
                                                            width: 2),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Defaults.white,
                                                            width: 2),
                                                  ),
                                                ),
                                                items: snapshot
                                                    .data!.survey!.page
                                                    .elementAt(pindex)
                                                    .questions
                                                    .elementAt(index)
                                                    .additional
                                                    .map((r) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: r, child: Text(r));
                                                }).toList(),
                                                onChanged: (value) => {}),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Text("Nada");
                                    }
                                  }),
                                ),
                              ],
                            );
                          }),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    }),
              ),

              ////-------- IMAGE ------///
              Container(child: StatefulBuilder(builder: (context, setState) {
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

              ///---------------- ZONE DE BOUTTON SUBMIT----------------
              ElevatedButton(
                // onPressed: _submitForm,
                onPressed: () {
                  _submitEUM();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
