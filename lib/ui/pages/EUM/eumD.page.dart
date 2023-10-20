// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_local_variable, use_build_context_synchronously

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
import 'package:unicefapp/models/dto/appsurveyextraction.dart';
import 'package:unicefapp/models/dto/survey.dart';
import 'package:unicefapp/models/dto/surveyExtraction.dart';
import 'package:unicefapp/ui/pages/eum.page.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unicefapp/widgets/loading.indicator.dart';

class EUMDetailsPage1 extends StatefulWidget {
  EUMDetailsPage1({super.key, required this.dtoSurveyExtration});

  final DTOSurveyExtration dtoSurveyExtration;

  @override
  State<EUMDetailsPage1> createState() => _EUMDetailsPage1State();
}

class _EUMDetailsPage1State extends State<EUMDetailsPage1> {
  TextEditingController zoneSaisieController = TextEditingController();
  late Future<AppSurveyExtraction> tableData;
  // AppSurveyExtraction? tableData2;
  List<TextEditingController> textEditingControllers = [];
  final Map<String, TextEditingController> textEditingControllers2 = HashMap();
  final storage = locator<TokenStorageService>();
  final _formKey = GlobalKey<FormState>();
  final dbHandler = locator<LocalService>();
  late final Future<Agent?> _futureAgentConnected;
  String apiResult = '';
  String userid = '';

  late TextEditingController radioButtonController;
  int? selectedValue;

  int i = 0;

  TextEditingController Question1Controller = TextEditingController();
  TextEditingController Question2Controller = TextEditingController();
  List<String> listOfRegion = [
    "Bafata",
    "Biombo",
    "Bolama",
    "Cacheu",
    "Gabu",
    "Oio",
    "Quinara",
    "Tombali",
    "Bissau",
  ];

  TextEditingController Question4Controller = TextEditingController();
  int selectedYesNoValue = 0; // 0 pour "Yes", 1 pour "No"

  TextEditingController Question5Controller = TextEditingController();
  List<String> listOfSeSim = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
  ];

  TextEditingController Question6Controller = TextEditingController();
  bool isQuestion6Visible = true; // Par défaut, le champ est visible

  TextEditingController Question7Controller = TextEditingController();
  List<String> listOfEstas_desposto_a_vacinar = [
    "SIM",
    "NAO",
  ];
  bool isQuestion8Visible = false;

  TextEditingController Question8Controller = TextEditingController();

  TextEditingController _selectedNumeroJoves = TextEditingController();
  List<String> listOfNumeroJoves = [
    "SIM",
    "NAO",
  ];

  TextEditingController Question9Controller = TextEditingController();
  List<String> listOfSex = [
    "M",
    "F",
  ];

  TextEditingController Question10Controller = TextEditingController();

  TextEditingController Question11Controller = TextEditingController();

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
  /*void _submitEUM() async {
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
    // textEditingControllers2.forEach((k, v) => request.fields[k] = v.value.text);
    request.fields["Question1Controller"] = "Nome Inqueridor";
    request.fields["Question2Controller"] = "Indique a Localidade";
    request.fields["Question3Controller"] =
        "Numero de jovens, seus pares informados e mobilizados a vacinar";
    request.fields["Question4Controller"] =
        "Jovens seus pares encontrados tem vacina contra Covid-19";
    request.fields["Question5Controller"] =
        "Se SIM, Tens quantas doses de vacina contra Covid-19";
    request.fields["Question6Controller"] = "Se NAO, Porque ?";
    request.fields["Question7Controller"] = "Estas desposto a vacinar ?";
    request.fields["Question8Controller"] = "Se NAO Porque ?";

    //-------RESPONSE---------//
    request.fields["Response1Controller"] = Question1Controller.text;
    request.fields["Response2Controller"] = Question2Controller.text;
    request.fields["Response3Controller"] = Question3Controller.text;
    request.fields["Response4Controller"] = Question4Controller.text;
    request.fields["Response5Controller"] = Question5Controller.text;
    request.fields["Response6Controller"] = Question6Controller.text;
    request.fields["Response7Controller"] = Question7Controller.text;
    request.fields["Response8Controller"] = Question8Controller.text;

    request.fields["idSurvey"] = widget.dtoSurveyExtration.survey_id;
    request.fields["size"] = "8";
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
  } */

  void _submitEUM() async {
    if (_formKey.currentState!.validate()) {
      LoadingIndicatorDialog().show(context);
      try {
        // id INTEGER PRIMARY KEY AUTOINCREMENT, survey_Sid TEXT, survey_Id TEXT, user TEXT, response TEXT, questions TEXT
        String surveySid = widget.dtoSurveyExtration.survey_id;
        //String surveyId = Uuid().v4();

        SurveyQuestionResponse surveyQuestionResponse1 = SurveyQuestionResponse(
            questionid: 1,
            question: "Indique a Localidade",
            response: Question1Controller.text);
        SurveyQuestionResponse surveyQuestionResponse2 = SurveyQuestionResponse(
            questionid: 2,
            question: "Bairro",
            response: Question2Controller.text);

        SurveyQuestionResponse surveyQuestionResponse4 = SurveyQuestionResponse(
            questionid: 4,
            question: "Joves seus pares encontrados tem vacina contra Covid-19",
            response: Question4Controller.text);

        SurveyQuestionResponse surveyQuestionResponse5 = SurveyQuestionResponse(
            questionid: 5,
            question: "Se SIM, Tens quantas doses de vacina contra Covid-19",
            response: Question5Controller.text);
        SurveyQuestionResponse surveyQuestionResponse6 = SurveyQuestionResponse(
            questionid: 6,
            question: "Se NAO, Porque ?",
            response: Question6Controller.text);
        SurveyQuestionResponse surveyQuestionResponse7 = SurveyQuestionResponse(
            questionid: 7,
            question: "Estas desposto a vacinar ?",
            response: Question7Controller.text);
        SurveyQuestionResponse surveyQuestionResponse8 = SurveyQuestionResponse(
            questionid: 8,
            question: "Se NAO Porque ?",
            response: Question8Controller.text);

        SurveyQuestionResponse surveyQuestionResponse9 = SurveyQuestionResponse(
            questionid: 9,
            question: "Sexo ",
            response: Question9Controller.text);

        SurveyQuestionResponse surveyQuestionResponse10 =
            SurveyQuestionResponse(
                questionid: 10,
                question: "Idade ",
                response: Question10Controller.text);

        SurveyQuestionResponse surveyQuestionResponse11 =
            SurveyQuestionResponse(
                questionid: 11,
                question: "Nome de Inquiridor ",
                response: Question11Controller.text);

        List<SurveyQuestionResponse> questionresponse = [];
        questionresponse.add(surveyQuestionResponse1);
        questionresponse.add(surveyQuestionResponse2);
        questionresponse.add(surveyQuestionResponse4);
        questionresponse.add(surveyQuestionResponse5);
        questionresponse.add(surveyQuestionResponse6);
        questionresponse.add(surveyQuestionResponse7);
        questionresponse.add(surveyQuestionResponse8);
        questionresponse.add(surveyQuestionResponse9);
        questionresponse.add(surveyQuestionResponse10);
        questionresponse.add(surveyQuestionResponse11);

        Survey survey = Survey(
            userid: userid,
            surveyid: surveySid,
            questionresponse: questionresponse);

        await await dbHandler.SaveEum(survey);
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
          child: Form(
            key: _formKey,
            child: Theme(
              data: ThemeData(primarySwatch: Defaults.primaryBleuColor),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Informacao',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Nome de Inquiridor',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ZoneSaisie(context, Question11Controller),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Indique a Localidade',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
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
                      value: Question1Controller.text.isNotEmpty
                          ? Question1Controller.text
                          : null,
                      hint: const Text(
                        'Select . . .',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          Question1Controller.text = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: listOfRegion.map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Bairro',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ZoneSaisie(context, Question2Controller),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Sexo ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
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
                      value: Question9Controller.text.isNotEmpty
                          ? Question9Controller.text
                          : null,
                      hint: const Text(
                        'Select . . .',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          Question9Controller.text = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: listOfSex.map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Idade',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ZoneSaisie(context, Question10Controller),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Inquerito',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Joves seus pares encontrados tem vacina contra Covid-19',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 5, // La valeur correspondante à "Yes"
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                  Question4Controller.text = 'Yes';
                                  isQuestion6Visible =
                                      false; // Masquer le champ Question6
                                });
                              },
                            ),
                            Text('Yes'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 6, // La valeur correspondante à "No"
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                  Question4Controller.text = 'No';
                                  isQuestion6Visible =
                                      true; // Afficher le champ Question6
                                });
                              },
                            ),
                            Text('No'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Se SIM, Tens quantas doses de vacina contra Covid-19',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
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
                      value: Question5Controller.text.isNotEmpty
                          ? Question5Controller.text
                          : null,
                      hint: const Text(
                        'Select . . .',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          Question5Controller.text = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: listOfSeSim.map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Visibility(
                    visible: isQuestion6Visible,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Se Nao, Porque ?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isQuestion6Visible,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ZoneSaisie(context, Question6Controller),
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Estas desposto a vacinar ?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
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
                      value: Question7Controller.text.isNotEmpty
                          ? Question7Controller.text
                          : null,
                      hint: const Text(
                        'Select . . .',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          Question7Controller.text = value!;
                          // isQuestion8Hidden = (value == "SIM");
                          isQuestion8Visible = value == "SIM" ? false : true;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: listOfEstas_desposto_a_vacinar.map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Visibility(
                    visible: isQuestion8Visible,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Se Nao, Porque ?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isQuestion8Visible,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ZoneSaisie(context, Question8Controller),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ////-------- IMAGE ------///
                  /* Container(
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
*/
                  ///---------------- ZONE DE BOUTTON SUBMIT----------------
                  ElevatedButton(
                    onPressed: () {
                      _submitEUM();
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
