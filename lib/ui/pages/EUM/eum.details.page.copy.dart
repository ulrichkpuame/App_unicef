// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/db/local.servie.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/SurveyQuestionResponse.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/survey.dart';
import 'package:unicefapp/models/dto/surveyCreation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:unicefapp/models/dto/surveyQuestion.dart';
import 'package:unicefapp/ui/pages/EUM/eum.page.copy.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class EUMDetailsPageCopy extends StatefulWidget {
  const EUMDetailsPageCopy({super.key, required this.surveyCreation});

  final SurveyCreation surveyCreation;

  @override
  State<EUMDetailsPageCopy> createState() => _EUMDetailsPageCopyState();
}

class _EUMDetailsPageCopyState extends State<EUMDetailsPageCopy> {
  TextEditingController zoneSaisieController = TextEditingController();
  late Future<List<SurveyCreation>> tableData;
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
  String BASEURL = 'https://www.trackiteum.org';

  late TextEditingController radioButtonController;
  int? selectedValue;
  Map<String, int?> selectedValues = {};
  bool hasInternet = false;

  int i = 0;

  @override
  void initState() {
    super.initState();
    _futureAgentConnected = getAgent();
    getAgent().then((value) => usercountry = value!.country);
    getAgent().then((value) => userid = value!.id);

    // Initialize tableData with an empty list
    tableData = Future.value([]);

    // Call _initializeTableData instead of directly assigning the future
    _initializeTableData();
  }

  // Code d'initialisation
  _initializeTableData() async {
    try {
      List<SurveyCreation> value = await _getEUMdetails(
          widget.surveyCreation.id, widget.surveyCreation.country);
      if (value.isNotEmpty) {
        value.forEach((data) {
          data.page.forEach((page) {
            page.questions.forEach((e) {
              var textEditingController = TextEditingController();
              textEditingControllers.add(textEditingController);
              textEditingControllers2['${page.page_id.toString()}_${e.index}'] =
                  textEditingController;
            });
          });
        });

        // Set tableData to Future.value only after the data is processed
        setState(() {
          tableData = Future.value(value);
        });
      }
    } catch (e) {
      print("Erreur lors de l'initialisation des données du tableau : $e");
      // Set tableData to an empty list in case of an error
      setState(() {
        tableData = Future.value([]);
      });
    }
  }

  // Fonction de lecture des données en local
  Future<List<SurveyCreation>> fetchSurveysFromLocal() async {
    // Utiliser readSurveyCreationById pour obtenir les détails de l'enquête spécifique
    SurveyCreation? specificSurvey =
        await dbHandler.readSurveyCreationById(widget.surveyCreation.id);

    // Utiliser readAllSurveyCreation pour obtenir toutes les enquêtes locales
    List<SurveyCreation> allSurveys = await dbHandler.readAllSurveyCreation();

    // Si une enquête spécifique est trouvée, la retourner
    if (specificSurvey != null) {
      return [specificSurvey];
    } else {
      // Sinon, retourner toutes les enquêtes locales
      return allSurveys;
    }
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
  Future<void> pickImage() async {
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
  Future<List<SurveyCreation>> _getEUMdetails(
      String surveyId, String usercountry) async {
    try {
      var response = await http.get(
          Uri.parse('$BASEURL/u/admin/SurveyByCountry/$usercountry/$surveyId'),
          headers: {"Content-type": "application/json"});

      if (response.statusCode == 200) {
        print(usercountry);
        print(surveyId);
        var jsonData = jsonDecode(response.body);
        return [SurveyCreation.fromJson(jsonData)];
      } else {
        // En cas d'échec de la requête au serveur, récupérer les données localement
        print(
            'Échec de la requête au serveur. Tentative de récupération locale.');
        var localData = await fetchSurveysFromLocal();
        if (localData.isNotEmpty) {
          print('Données locales récupérées avec succès 1.');
          return localData; // Return localData instead of localData.first
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
        print('Données locales récupérées avec succès 2.');
        print(localData);
        return localData;
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
            String response;

            // Traitement en fonction du type de question
            if (widget.surveyCreation.page[i].questions[j].type ==
                'Case a Cocher') {
              // Traitement pour les questions QCM
              String key = '$i-$j';
              response = textEditingControllers2[key]!.text;
            } else if (widget.surveyCreation.page[i].questions[j].type ==
                'QCM') {
              // Traitement pour les questions QCM
              List<String> selectedOptions = textEditingControllers
                  .map((controller) => controller.text)
                  .toList();
              response = selectedOptions.join(
                  ', '); // Vous pouvez adapter cette logique selon vos besoins
            } else if (widget.surveyCreation.page[i].questions[j].type ==
                'Zone de saisie') {
              // Traitement pour les questions de type Zone de saisie
              response = textEditingControllers[j].text;
            } else if (widget.surveyCreation.page[i].questions[j].type ==
                'Liste deroulante') {
              // Traitement pour les questions de type Liste déroulante
              response = textEditingControllers[i].text;
            } else {
              // Gérer les autres types de questions ici
              response = 'N/A';
            }

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
                  child: FutureBuilder<List<SurveyCreation>>(
                    future: tableData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erreur : ${snapshot.error}');
                      } else {
                        if (snapshot.hasData) {
                          return buildFormFromApiData(snapshot.data);
                        } else {
                          // Gérer le cas où les données API et locales ne sont pas disponibles
                          return Text('Pas de données disponibles.');
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
              ElevatedButton.icon(
                onPressed: () {
                  _saveEUM();
                },
                icon:
                    Icon(Icons.cloud_download_outlined, color: Defaults.white),
                label: Text(
                  AppLocalizations.of(context)!.save,
                  style: TextStyle(color: Defaults.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormFromApiData(List<SurveyCreation>? data) {
    return Column(
      children:
          data!.map((surveyCreation) => buildForm(surveyCreation)).toList(),
    );
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

  Widget buildQuestionWidget(SurveyQuestion question, int pindex, int index) {
    if (question.type.toString() == 'QCM') {
      return buildMultipleChoiceQuestion(question, pindex, index);
    } else if (question.type.toString() == 'Case a Cocher') {
      return buildRadioButtonChoiceQuestion(question, pindex, index);
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
    TextEditingController textEditingController =
        textEditingControllers[index] ?? TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          ElevatedButton.icon(
            label: Text(
              'Sélectionner',
              style: TextStyle(color: Defaults.white),
            ),
            icon: const Icon(Icons.arrow_circle_down, color: Defaults.white),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
            ),
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MultiSelectDialog(
                    height: 300,
                    items: question.additional
                        .map((option) => MultiSelectItem(option, option))
                        .toList(),
                    initialValue: textEditingControllers
                        .map((controller) => controller.text)
                        .toList(),
                  );
                },
              );

              if (result != null) {
                setState(() {
                  // Mettez à jour les contrôleurs de texte
                  textEditingControllers
                      .clear(); // Efface les contrôleurs existants

                  for (int i = 0; i < result.length; i++) {
                    // Ajoutez un nouveau contrôleur pour chaque option sélectionnée
                    textEditingControllers.add(
                      TextEditingController(text: result[i]),
                    );
                  }
                });
              }
            },
          ),
          SizedBox(height: 8.0),
          // Affichez les options sélectionnées uniquement si elles existent
          if (textEditingControllers.isNotEmpty)
            Container(
              width: double.infinity, // Occupe toute la largeur disponible
              decoration: BoxDecoration(
                color: Defaults.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Options sélectionnées:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Utiliser un Wrap à la place d'un Row pour gérer les retours à la ligne
                  Wrap(
                    children: textEditingControllers
                        .map(
                          (controller) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(controller.text),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildRadioButtonChoiceQuestion(
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

  Widget buildRadioButton(String label, int value, int pindex, int index) {
    String key =
        '$pindex-$index'; // Utilisez une clé unique pour chaque paire (pindex, index)

    // Initialisez le contrôleur de texte s'il n'existe pas encore
    textEditingControllers2.putIfAbsent(key, () => TextEditingController());

    return Row(
      children: [
        Radio(
          value: value,
          groupValue: selectedValues[
              key], // Utilisez une valeur de groupe différente pour chaque paire (pindex, index)
          onChanged: (newValue) {
            setState(() {
              selectedValues[key] =
                  newValue; // Mettez à jour la valeur sélectionnée pour la paire (pindex, index)
              // Mettez à jour le contrôleur de texte
              textEditingControllers2[key]!.text = label;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  Widget buildTextEntryQuestion(
      SurveyQuestion question, int pindex, int index) {
    // Utilisez un nouveau contrôleur de texte pour chaque champ de zone de saisie
    TextEditingController textEditingController =
        textEditingControllers[index] ?? TextEditingController();

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
          ZoneSaisie(context, textEditingController),
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
            onChanged: (value) {
              // Mettez à jour le contrôleur de texte associé à ce champ spécifique
              textEditingControllers[pindex] =
                  TextEditingController(text: value ?? '');
            },
          ),
        ],
      ),
    );
  }
}
