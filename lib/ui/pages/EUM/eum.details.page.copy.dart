// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_local_variable, use_build_context_synchronously

import 'dart:io';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/db/local.servie.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/SurveyQuestionResponse.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/survey.dart';
import 'package:unicefapp/models/dto/surveyCreation.dart';
import 'package:unicefapp/models/dto/surveyQuestion.dart';
import 'package:unicefapp/ui/pages/EUM/eum.page.copy.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';

class EUMDetailsPageCopy extends StatefulWidget {
  const EUMDetailsPageCopy({super.key, required this.surveyCreation});

  final SurveyCreation surveyCreation;

  @override
  State<EUMDetailsPageCopy> createState() => _EUMDetailsPageCopyState();
}

class _EUMDetailsPageCopyState extends State<EUMDetailsPageCopy> {
  TextEditingController zoneSaisieController = TextEditingController();
  late Future<SurveyCreation> tableData;
  SurveyCreation? surveyCreation;
  final dbHandler = locator<LocalService>();
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> textEditingControllers = [];
  final Map<String, TextEditingController> textEditingControllers2 = HashMap();
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;
  String apiResult = '';
  String userid = '';
  String usercountry = '';
  String BASEURL = 'http://192.168.1.4:8096';

  late TextEditingController radioButtonController;
  int? selectedValue;
  bool hasInternet = false;

  int i = 0;

  @override
  void initState() {
    super.initState();
    _futureAgentConnected = getAgent();
    getAgent().then((value) => usercountry = value!.country);
    getAgent().then((value) => userid = value!.id);

    print('Connexion internet active');
    tableData =
        _getEUMdetails(widget.surveyCreation.id, widget.surveyCreation.country);
    tableData.then((value) {
      value.page.forEach((page) {
        page.questions.forEach((e) {
          var textEditingController = TextEditingController();
          textEditingControllers.add(textEditingController);
          textEditingControllers2['${page.page_id.toString()}_${e.index}'] =
              textEditingController;
        });
      });
    });
  }

  Future<List<SurveyCreation>> fetchSurveysFromLocal() async {
    return await dbHandler.getSurveys();
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
  Future<SurveyCreation> _getEUMdetails(
      String surveyId, String usercountry) async {
    try {
      var response = await http.get(
          Uri.parse('$BASEURL/u/admin/SurveyByCountry/$usercountry/$surveyId'),
          headers: {"Content-type": "application/json"});

      if (response.statusCode == 200) {
        print(usercountry);
        print(surveyId);
        var jsonData = jsonDecode(response.body);
        return SurveyCreation.fromJson(jsonData);
      } else {
        // En cas d'échec de la requête au serveur, récupérer les données localement
        print(
            'Échec de la requête au serveur. Tentative de récupération locale.');
        var localData = await fetchSurveysFromLocal();
        if (localData.isNotEmpty) {
          print('Données locales récupérées avec succès.');
          return localData.first;
        } else {
          print('Pas de données locales disponibles.');
          throw Exception('Échec du chargement EUM: ${response.statusCode}');
        }
      }
    } catch (e) {
      // En cas d'erreur réseau, récupérer les données localement
      print('Erreur réseau. Tentative de récupération locale : $e');
      var localData = await fetchSurveysFromLocal();
      if (localData.isNotEmpty) {
        print('Données locales récupérées avec succès.');
        return localData.first;
      } else {
        print('Pas de données locales disponibles : $e');
        throw Exception('Échec du chargement EUM: $e');
      }
    }
  }

// ---------- ID AGENT CONNECTED ---------------//
  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  void _saveEUM() async {
    if (_formKey.currentState!.validate()) {
      LoadingIndicatorDialog().show(context);
      try {
        String surveySid = widget.surveyCreation.id;

        // Liste pour stocker les réponses aux questions
        List<SurveyQuestionResponse> questionResponses = [];

        // Parcourir les pages de l'API
        for (int i = 0; i < widget.surveyCreation.page.length; i++) {
          // Parcourir les questions de chaque page
          for (int j = 0;
              j < widget.surveyCreation.page[i].questions.length;
              j++) {
            // Récupérer les données de la question
            int questionId =
                int.parse(widget.surveyCreation.page[i].questions[j].index);
            String questionText =
                widget.surveyCreation.page[i].questions[j].text;
            String response = textEditingControllers[
                    i * widget.surveyCreation.page[i].questions.length + j]
                .text;

            // Créer l'objet SurveyQuestionResponse
            SurveyQuestionResponse questionResponse = SurveyQuestionResponse(
              questionid: questionId,
              country: usercountry,
              question: questionText,
              response: response,
            );

            // Ajouter la réponse à la liste
            questionResponses.add(questionResponse);
          }
        }

        // Créer l'objet Survey avec les réponses
        Survey survey = Survey(
          userid: userid,
          country: usercountry,
          surveyid: surveySid,
          questionresponse: questionResponses,
        );

        // Enregistrer les données dans la base de données
        await dbHandler.SaveEum(survey);
        LoadingIndicatorDialog().dismiss();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'SUCESSO',
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
                    'Atualisaçao effectua com sucesso',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const HomePage()));
                  },
                  child: const Text('VOLTAR'))
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
              title: const Text(
                'ERRO',
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
                    const Text(
                      'Erro occoreu durante atualiçao',
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
                    child: const Text('Tenta de novo'))
              ],
            );
          },
        );
      }
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
                      MaterialPageRoute(builder: (context) => EUMPageCopy()),
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
                child: Form(
                  key: _formKey,
                  child: FutureBuilder<SurveyCreation?>(
                    future: tableData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Afficher un indicateur de chargement pendant que les données sont en cours de chargement
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Afficher un message d'erreur si une erreur se produit
                        return Text('Erreur: ${snapshot.error}');
                      } else {
                        // Les données sont prêtes, vous pouvez maintenant afficher le formulaire
                        if (snapshot.hasData) {
                          // Connexion disponible, affiche le formulaire basé sur les données API
                          return buildFormFromApiData(snapshot.data);
                        } else {
                          // Pas de connexion, récupérer les données locales et afficher le formulaire basé sur les données locales
                          return FutureBuilder<SurveyCreation>(
                            future: tableData,
                            builder: (context, localSnapshot) {
                              if (localSnapshot.connectionState ==
                                  ConnectionState.none) {
                                print('-----------------');
                                print(fetchSurveysFromLocal().toString());
                                // Afficher un indicateur de chargement pendant que les données locales sont en cours de chargement
                                return CircularProgressIndicator();
                              } else if (localSnapshot.hasError) {
                                // Afficher un message d'erreur si une erreur se produit lors du chargement des données locales
                                return Text(
                                    'Erreur locale: ${localSnapshot.error}');
                              } else {
                                // Afficher le formulaire basé sur les données locales
                                if (localSnapshot.data != null &&
                                    localSnapshot.data!.page.isNotEmpty) {
                                  print('---------  SNAPSHOT  -----------');
                                  print(localSnapshot.data);
                                  return buildFormFromLocalData(
                                      localSnapshot.data!.page as List<
                                          SurveyCreation>); // Affichez le premier élément, ajustez selon vos besoins
                                } else {
                                  return Text(
                                      'Pas de données locales disponibles.');
                                }
                              }
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
              ),

              ////-------- IMAGE ------///
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
              }),

              ///---------------- ZONE DE BOUTTON SUBMIT----------------
              ElevatedButton(
                onPressed: () {
                  _saveEUM();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormFromApiData(SurveyCreation? data) {
    this.surveyCreation = data;
    return buildForm(data);
  }

  Widget buildFormFromLocalData(List<SurveyCreation> localData) {
    print('------ LOCAL DATA  --------');
    print(localData);
    return buildForm(localData.isNotEmpty ? localData.first : null);
  }

  Widget buildForm(SurveyCreation? data) {
    return Column(
      children: List.generate(data?.page.length ?? 0, (pindex) {
        var currentPage = data!.page.elementAt(pindex);
        print('------ ONLINE  --------');
        print(data.page);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  currentPage.page_name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: List.generate(currentPage.questions.length, (index) {
                var currentQuestion = currentPage.questions.elementAt(index);
                return buildQuestionWidget(currentQuestion, pindex, index);
              }),
            ),
          ],
        );
      }),
    );
  }

  /*Widget buildForm1(SurveyCreation? localData) {
    print('------ OFFLINE  --------');
    print(localData!.page);
    return Column(
      children: List.generate(localData?.page.length ?? 0, (pindex) {
        var currentPage = localData!.page.elementAt(pindex);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  currentPage.page_name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: List.generate(currentPage.questions.length, (index) {
                var currentQuestion = currentPage.questions.elementAt(index);
                return buildQuestionWidget(currentQuestion, pindex, index);
              }),
            ),
          ],
        );
      }),
    );
  }*/

  Widget buildQuestionWidget(SurveyQuestion question, int pindex, int index) {
    if (question.type.toString() == 'QCM' ||
        question.type.toString() == 'Case a Cocher') {
      return buildMultipleChoiceQuestion(question, pindex, index);
    } else if (question.type.toString() == 'Zone de saisie') {
      return buildTextEntryQuestion(question, pindex, index);
    } else if (question.type.toString() == 'Liste deroulante') {
      return buildDropdownQuestion(question, pindex, index);
    } else {
      return Text("Nada");
    }
  }

  Widget buildMultipleChoiceQuestion(
      SurveyQuestion question, int pindex, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              question.text.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildRadioButton('Yes', 5, pindex, index),
                buildRadioButton('No', 6, pindex, index),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextEntryQuestion(
      SurveyQuestion question, int pindex, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              question.text.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          ZoneSaisie(context, textEditingControllers.elementAt(index)),
        ],
      ),
    );
  }

  Widget buildDropdownQuestion(SurveyQuestion question, int pindex, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              question.text.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            hint: Text("Select . . ."),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
            items: question.additional.map((r) {
              return DropdownMenuItem<String>(
                value: r,
                child: Text(r),
              );
            }).toList(),
            onChanged: (value) => {},
          ),
        ],
      ),
    );
  }

  Widget buildRadioButton(String label, int value, int pindex, int index) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: selectedValue,
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue;
              textEditingControllers2[
                      '${surveyCreation!.page.elementAt(pindex).page_id}_${surveyCreation!.page.elementAt(pindex).questions.elementAt(index).index}']!
                  .text = label;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
