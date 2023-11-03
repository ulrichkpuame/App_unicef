// ignore_for_file: non_constant_identifier_names

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/db/local.servie.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/SurveyQuestionResponse.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/appsurveyextraction.dart';
import 'package:unicefapp/models/dto/survey.dart';
import 'package:unicefapp/models/dto/surveyExtraction.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:http/http.dart' as http;
import 'package:unicefapp/widgets/loading.indicator.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class QuestionarioDeObservacaoPage extends StatefulWidget {
  QuestionarioDeObservacaoPage({super.key, required this.dtoSurveyExtration});

  final DTOSurveyExtration dtoSurveyExtration;

  @override
  State<QuestionarioDeObservacaoPage> createState() =>
      _QuestionarioDeObservacaoPageState();
}

class _QuestionarioDeObservacaoPageState
    extends State<QuestionarioDeObservacaoPage> {
  final _formKey = GlobalKey<FormState>();
  final storage = locator<TokenStorageService>();
  final dbHandler = locator<LocalService>();
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  String selectedRegiao = ''; // Région par défaut
  String selectedAreas = ''; // Ville par défaut
  String selectedNameInvestigador = "";
  String selectedOption = '';
  String userid = '';

  late Future<AppSurveyExtraction> tableData;
  List<TextEditingController> textEditingControllers = [];
  final Map<String, TextEditingController> textEditingControllers2 = HashMap();

  Map<String, List<String>> regionCities = {
    'BAFATA': ['Bafata', 'Bambadinca', 'Contuboel', 'Cosse', 'Xitole'],
    'BIJAGOS': ['Bubaque', 'Caravela', 'Bolama', 'Uno'],
    'BIOMBO': ['Quinhamel', 'Safim', 'Prabis'],
    'CACHEU': ['S.Domingos', 'Cantchungo', 'Bula', 'Bigene', 'Cacheu', 'Caio'],
    'GABU': ['Gabu', 'Pitche', 'Sonaco', 'Pirada', 'Beli'],
    'OIO-FARIM': ['Mansoa', 'Bissora', 'Nhacra', 'Mansaba', 'Farim'],
    'QUINARA': ['Buba', 'Empada', 'Fulacunda', 'Tite'],
    'SAB': ['Antula', 'B. Militar', 'Bandim', 'Cuntum', 'Plaque 2'],
    'TOMBALI': ['Cacine', 'Bedanda', 'Catio', 'Komo', 'Quebo'],
  };

  List<String> listOfPessoasEntrevistadas = [
    "Director",
    "RAS",
    "Chefe do centro",
    "PF PAV",
    "Outros",
  ];

  List<String> listOfResponses = ["SIM", "NAO", "NA"];
  List<String> listOfSimNao = ["SIM", "NAO"];
  List<String> listOfTiempoMinuto = ["<2 min", "2-5 min", ">5 min"];
  List<String> listOfTiempoHora = ["<1 h", "1-2 h", ">3 h"];

  List<String> listOfNameInvestigador = [
    "Miladenimar Vaz",
    "Venicio de Carvalho",
    "Yaouba Djaligué",
    "Victor Bessa",
    "N'dei Soares",
    "Carlota M.Ca",
    "Gibril Sarr",
    "Quecuto Nhaga",
    "Deborah Herbert",
  ];

  ///--------- STEPPER 1 ------------/////

  TextEditingController nomeIvestigadorController = TextEditingController();
  TextEditingController numeroInvestigadorController = TextEditingController();
  TextEditingController regiaoController = TextEditingController();
  TextEditingController areaDaSanitariaController = TextEditingController();
  TextEditingController perssoasEntrevistadasController =
      TextEditingController();
  TextEditingController numeroPersssoasEntreviController =
      TextEditingController();
  TextEditingController nommePersssoasEntreviController =
      TextEditingController();
  TextEditingController centroDeSaudeController = TextEditingController();

  ///--------- STEPPER 2 ------------/////
  TextEditingController Question1Controller = TextEditingController();
  TextEditingController Question2Controller = TextEditingController();
  TextEditingController Question3Controller = TextEditingController();
  TextEditingController Question4Controller = TextEditingController();
  TextEditingController Question5Controller = TextEditingController();
  TextEditingController Question6Controller = TextEditingController();
  TextEditingController Question7Controller = TextEditingController();
  TextEditingController Question8Controller = TextEditingController();
  TextEditingController Question9Controller = TextEditingController();
  TextEditingController Question10Controller = TextEditingController();

  ///--------- STEPPER 2 ------------/////
  TextEditingController Question11Controller = TextEditingController();
  TextEditingController Question12Controller = TextEditingController();
  TextEditingController Question13Controller = TextEditingController();
  TextEditingController Question14Controller = TextEditingController();
  TextEditingController Question15Controller = TextEditingController();
  TextEditingController Question16Controller = TextEditingController();
  TextEditingController Question17Controller = TextEditingController();
  TextEditingController Question18Controller = TextEditingController();
  TextEditingController Question19Controller = TextEditingController();
  TextEditingController Question20Controller = TextEditingController();
  TextEditingController Question21Controller = TextEditingController();
  TextEditingController Question22Controller = TextEditingController();
  TextEditingController Question23Controller = TextEditingController();
  TextEditingController Question24Controller = TextEditingController();
  TextEditingController Question25Controller = TextEditingController();
  TextEditingController Question26Controller = TextEditingController();
  TextEditingController Question27Controller = TextEditingController();
  TextEditingController Question28Controller = TextEditingController();
  TextEditingController Question29Controller = TextEditingController();
  TextEditingController Question30Controller = TextEditingController();

  // ---------- ID AGENT CONNECTED ---------------//
  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
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

  //----------------- API SUBMIT ET FENETRE POP-UP DE SUCCESS-----------------//

  void _submitEUM() async {
    if (_formKey.currentState!.validate()) {
      LoadingIndicatorDialog().show(context);
      try {
        // id INTEGER PRIMARY KEY AUTOINCREMENT, survey_Sid TEXT, survey_Id TEXT, user TEXT, response TEXT, questions TEXT
        String surveySid = widget.dtoSurveyExtration.survey_id;
        //String surveyId = Uuid().v4();

        SurveyQuestionResponse surveyQuestionResponse00 =
            SurveyQuestionResponse(
                questionid: 0,
                question: "Data de administração",
                response: DateTime.now().toString());
        SurveyQuestionResponse surveyQuestionResponse0 = SurveyQuestionResponse(
            questionid: 0,
            question: "Nome e apelido do Investigador",
            response: nomeIvestigadorController.text);
        SurveyQuestionResponse surveyQuestionResponse1 = SurveyQuestionResponse(
            questionid: 1,
            question: "Numero de TEL",
            response: numeroInvestigadorController.text);
        SurveyQuestionResponse surveyQuestionResponse2 = SurveyQuestionResponse(
            questionid: 2, question: "Região", response: regiaoController.text);
        SurveyQuestionResponse surveyQuestionResponse3 = SurveyQuestionResponse(
            questionid: 3,
            question: "Área da Sanitaria",
            response: areaDaSanitariaController.text);
        SurveyQuestionResponse surveyQuestionResponse4 = SurveyQuestionResponse(
            questionid: 4,
            question: "CENTRO DE SAUDE",
            response: perssoasEntrevistadasController.text);
        SurveyQuestionResponse surveyQuestionResponse5 = SurveyQuestionResponse(
            questionid: 5,
            question: "Pessoas entrevistadas",
            response: numeroPersssoasEntreviController.text);
        SurveyQuestionResponse surveyQuestionResponse6 = SurveyQuestionResponse(
            questionid: 6,
            question: "Numero TEL",
            response: nommePersssoasEntreviController.text);
        SurveyQuestionResponse surveyQuestionResponse7 = SurveyQuestionResponse(
            questionid: 7,
            question: "Nomes",
            response: centroDeSaudeController.text);
        SurveyQuestionResponse surveyQuestionResponse8 = SurveyQuestionResponse(
            questionid: 8,
            question:
                "A sala de espera é confortável, nao exposto ao sol, chuvas e se encontra limpio",
            response: Question1Controller.text);
        SurveyQuestionResponse surveyQuestionResponse9 = SurveyQuestionResponse(
            questionid: 9,
            question: "Existe uma mesa e uma cadeira para o agente de saúde?",
            response: Question2Controller.text);
        SurveyQuestionResponse surveyQuestionResponse10 =
            SurveyQuestionResponse(
                questionid: 10,
                question:
                    "Existem casas de banho para as mães no centro de saudel?",
                response: Question3Controller.text);
        SurveyQuestionResponse surveyQuestionResponse11 =
            SurveyQuestionResponse(
                questionid: 11,
                question: "Existe uma televisão ou um ecrã de projeção?",
                response: Question4Controller.text);
        SurveyQuestionResponse surveyQuestionResponse12 = SurveyQuestionResponse(
            questionid: 12,
            question:
                "Existe um caixote do lixo ao alcance do responsável pela vacinação?",
            response: Question5Controller.text);
        SurveyQuestionResponse surveyQuestionResponse13 = SurveyQuestionResponse(
            questionid: 13,
            question:
                "O calendário de vacinação de rotina está fixado na parede?",
            response: Question6Controller.text);
        SurveyQuestionResponse surveyQuestionResponse14 =
            SurveyQuestionResponse(
                questionid: 14,
                question: "Existe um mapa da área sanitaria fixado na parede?",
                response: Question7Controller.text);
        SurveyQuestionResponse surveyQuestionResponse15 = SurveyQuestionResponse(
            questionid: 15,
            question:
                "Existem cartazes sobre PAV de rotina  no sítio ou Centro de Saude?",
            response: Question8Controller.text);
        SurveyQuestionResponse surveyQuestionResponse16 =
            SurveyQuestionResponse(
                questionid: 16,
                question:
                    "O serviço dispõe de um álbum seriado sobre a vacinação?",
                response: Question9Controller.text);
        SurveyQuestionResponse surveyQuestionResponse17 =
            SurveyQuestionResponse(
                questionid: 17,
                question: "O Centro de Saude dispõe de um megafone?",
                response: Question10Controller.text);
        SurveyQuestionResponse surveyQuestionResponse18 = SurveyQuestionResponse(
            questionid: 18,
            question:
                "Existe um sistema de triagem ou de ordenação das mães e das crianças em função da sua chegada?",
            response: Question11Controller.text);
        SurveyQuestionResponse surveyQuestionResponse19 =
            SurveyQuestionResponse(
                questionid: 19,
                question: "Falou que vacinas são administradas nesse dia?",
                response: Question12Controller.text);
        SurveyQuestionResponse surveyQuestionResponse20 =
            SurveyQuestionResponse(
                questionid: 20,
                question: "Informou sobre possíveis efeitos secundários?",
                response: Question13Controller.text);
        SurveyQuestionResponse surveyQuestionResponse21 = SurveyQuestionResponse(
            questionid: 21,
            question:
                "Indicou quando é que a criança deve regressar e regista a data (no cartão de vacinacao da criança)?",
            response: Question14Controller.text);
        SurveyQuestionResponse surveyQuestionResponse22 = SurveyQuestionResponse(
            questionid: 22,
            question:
                "Aconselhou as maes e tutoras da criança a trazer sempre o cartão de vacinacao da criança?",
            response: Question15Controller.text);
        SurveyQuestionResponse surveyQuestionResponse23 =
            SurveyQuestionResponse(
                questionid: 23,
                question:
                    "Convidou as maes e tutoras da criança a fazer perguntas?",
                response: Question16Controller.text);
        SurveyQuestionResponse surveyQuestionResponse24 = SurveyQuestionResponse(
            questionid: 24,
            question:
                "Existe o Gel de desinfeção des mãos no sitio da vacinação?",
            response: Question17Controller.text);
        SurveyQuestionResponse surveyQuestionResponse25 =
            SurveyQuestionResponse(
                questionid: 25,
                question:
                    "Desinfecta as mãos  depois de cada ato de vacinação?",
                response: Question18Controller.text);
        SurveyQuestionResponse surveyQuestionResponse26 = SurveyQuestionResponse(
            questionid: 26,
            question:
                "O vacinador foi simpático (cumprimentou, sorriu, despediu-se)?",
            response: Question19Controller.text);
        SurveyQuestionResponse surveyQuestionResponse27 = SurveyQuestionResponse(
            questionid: 27,
            question:
                "O vacinador explicou das vacinas administradas e das doenças que cobrem?",
            response: Question20Controller.text);
        SurveyQuestionResponse surveyQuestionResponse28 =
            SurveyQuestionResponse(
                questionid: 28,
                question:
                    "O vacinador perguntou à mãe se ela tinha alguma dúvida?",
                response: Question21Controller.text);
        SurveyQuestionResponse surveyQuestionResponse29 = SurveyQuestionResponse(
            questionid: 29,
            question:
                "O vacinador ouviu as preocupações e os receios da mãe e respondeu-lhe com ponderação?  ",
            response: Question22Controller.text);
        SurveyQuestionResponse surveyQuestionResponse30 =
            SurveyQuestionResponse(
                questionid: 30,
                question: "O vacinador agradeceu e/ou felicitou a mãe?",
                response: Question23Controller.text);
        SurveyQuestionResponse surveyQuestionResponse31 =
            SurveyQuestionResponse(
                questionid: 31,
                question: "O vacinador não se apressou no seu trabalho?",
                response: Question24Controller.text);
        SurveyQuestionResponse surveyQuestionResponse32 = SurveyQuestionResponse(
            questionid: 32,
            question:
                "Quanto tempo é que o vacinador passou a falar com o prestador de cuidados? ",
            response: Question25Controller.text);
        SurveyQuestionResponse surveyQuestionResponse33 =
            SurveyQuestionResponse(
                questionid: 33,
                question:
                    "Quanto tempo é que a mãe esperou para ser atendida? ",
                response: Question26Controller.text);
        SurveyQuestionResponse surveyQuestionResponse34 =
            SurveyQuestionResponse(
                questionid: 34,
                question:
                    "Houve alguma sessão educativa durante esta vacinação?",
                response: Question27Controller.text);
        SurveyQuestionResponse surveyQuestionResponse35 = SurveyQuestionResponse(
            questionid: 35,
            question:
                "Adoptou uma postura académica adequada? O animador põe os participantes à vontade: conta uma história engraçada, dança, etc.?",
            response: Question28Controller.text);
        SurveyQuestionResponse surveyQuestionResponse36 = SurveyQuestionResponse(
            questionid: 36,
            question:
                "O conteúdo foi desenvolvido: história real, utilização de recursos visuais?",
            response: Question29Controller.text);
        SurveyQuestionResponse surveyQuestionResponse37 = SurveyQuestionResponse(
            questionid: 37,
            question:
                "Discutiu com os participantes, tendo em conta as suas preocupações, respondendo às perguntas com cortesia?",
            response: Question30Controller.text);

        List<SurveyQuestionResponse> questionresponse = [];
        questionresponse.add(surveyQuestionResponse00);
        questionresponse.add(surveyQuestionResponse0);
        questionresponse.add(surveyQuestionResponse1);
        questionresponse.add(surveyQuestionResponse2);
        questionresponse.add(surveyQuestionResponse3);
        questionresponse.add(surveyQuestionResponse4);
        questionresponse.add(surveyQuestionResponse5);
        questionresponse.add(surveyQuestionResponse6);
        questionresponse.add(surveyQuestionResponse7);
        questionresponse.add(surveyQuestionResponse8);
        questionresponse.add(surveyQuestionResponse9);
        questionresponse.add(surveyQuestionResponse10);
        questionresponse.add(surveyQuestionResponse11);
        questionresponse.add(surveyQuestionResponse12);
        questionresponse.add(surveyQuestionResponse13);
        questionresponse.add(surveyQuestionResponse14);
        questionresponse.add(surveyQuestionResponse15);
        questionresponse.add(surveyQuestionResponse16);
        questionresponse.add(surveyQuestionResponse17);
        questionresponse.add(surveyQuestionResponse18);
        questionresponse.add(surveyQuestionResponse19);
        questionresponse.add(surveyQuestionResponse20);
        questionresponse.add(surveyQuestionResponse21);
        questionresponse.add(surveyQuestionResponse22);
        questionresponse.add(surveyQuestionResponse23);
        questionresponse.add(surveyQuestionResponse24);
        questionresponse.add(surveyQuestionResponse25);
        questionresponse.add(surveyQuestionResponse26);
        questionresponse.add(surveyQuestionResponse27);
        questionresponse.add(surveyQuestionResponse28);
        questionresponse.add(surveyQuestionResponse29);
        questionresponse.add(surveyQuestionResponse30);
        questionresponse.add(surveyQuestionResponse31);
        questionresponse.add(surveyQuestionResponse32);
        questionresponse.add(surveyQuestionResponse33);
        questionresponse.add(surveyQuestionResponse34);
        questionresponse.add(surveyQuestionResponse35);
        questionresponse.add(surveyQuestionResponse36);
        questionresponse.add(surveyQuestionResponse37);

        Survey survey = Survey(
            userid: userid,
            surveyid: surveySid,
            questionresponse: questionresponse);

        await dbHandler.SaveEum(survey);
        LoadingIndicatorDialog().dismiss();
        // ignore: use_build_context_synchronously
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

        // ignore: use_build_context_synchronously
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
    regiaoController = TextEditingController(text: selectedRegiao);
    areaDaSanitariaController = TextEditingController(text: selectedAreas);
  }

  @override
  void dispose() {
    ///--------- STEPPER 1 ------------/////
    nomeIvestigadorController.dispose();
    numeroInvestigadorController.dispose();
    regiaoController.dispose();
    areaDaSanitariaController.dispose();
    perssoasEntrevistadasController.dispose();
    numeroPersssoasEntreviController.dispose();
    nommePersssoasEntreviController.dispose();
    centroDeSaudeController.dispose();

    ///--------- STEPPER 2 ------------/////
    Question1Controller.dispose();
    Question2Controller.dispose();
    Question3Controller.dispose();
    Question4Controller.dispose();
    Question5Controller.dispose();
    Question6Controller.dispose();
    Question7Controller.dispose();
    Question8Controller.dispose();
    Question9Controller.dispose();
    Question10Controller.dispose();

    ///--------- STEPPER 3 ------------/////
    Question11Controller.dispose();
    Question12Controller.dispose();
    Question13Controller.dispose();
    Question14Controller.dispose();
    Question15Controller.dispose();
    Question16Controller.dispose();
    Question17Controller.dispose();
    Question18Controller.dispose();
    Question19Controller.dispose();
    Question20Controller.dispose();
    Question21Controller.dispose();
    Question22Controller.dispose();
    Question23Controller.dispose();
    Question24Controller.dispose();
    Question25Controller.dispose();
    Question26Controller.dispose();
    Question27Controller.dispose();
    Question28Controller.dispose();
    Question29Controller.dispose();
    Question30Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
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
          title: const Text(
            'Questionário de observação',
            softWrap: true,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
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
                    ] else if (_currentStep == 2) ...[
                      ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Previous',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                      ElevatedButton(
                          onPressed: () {
                            _submitEUM();
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
                ///--------- STEPPER 1-----------//////
                Step(
                  title: const Text("Investigador informação",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Nome e apelido do Investigador"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoCompleteTextField<String>(
                          key: GlobalKey(),
                          suggestions: listOfNameInvestigador,
                          clearOnSubmit: false,
                          textInputAction: TextInputAction.next,
                          controller: nomeIvestigadorController,
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
                            hintText: "Nome e apelido do Investigador",
                          ),
                          itemFilter: (item, query) {
                            return item
                                .toLowerCase()
                                .contains(query.toLowerCase());
                          },
                          itemSorter: (a, b) {
                            return a.compareTo(b);
                          },
                          itemSubmitted: (item) {
                            setState(() {
                              selectedNameInvestigador = item;
                            });
                          },
                          itemBuilder: (context, item) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            );
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Numero de TEL"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            ZoneSaisie(context, numeroInvestigadorController),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Região"),
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
                              borderSide: const BorderSide(
                                  color: Defaults.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Defaults.white, width: 2),
                            ),
                          ),
                          value: regiaoController.text.isNotEmpty
                              ? regiaoController.text
                              : null,
                          hint: const Text('Select Regiao'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Select Sanitaria';
                            }
                            return null;
                          },
                          items: regionCities.keys.map((String region) {
                            return DropdownMenuItem<String>(
                              value: region,
                              child: Text(region),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedRegiao = newValue!;
                              regiaoController.text = newValue;
                            });
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Área da Sanitaria"),
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
                              borderSide: const BorderSide(
                                  color: Defaults.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Defaults.white, width: 2),
                            ),
                          ),
                          value: areaDaSanitariaController.text.isNotEmpty
                              ? areaDaSanitariaController.text
                              : null,
                          hint: const Text('Select Sanitaria'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Select Sanitaria';
                            }
                            return null;
                          },
                          items:
                              regionCities[selectedRegiao]?.map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedAreas = newValue!;
                              areaDaSanitariaController.text = newValue;
                            });
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("CENTRO DE SAUDE"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ZoneSaisie(context, centroDeSaudeController),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Pessoas entrevistadas:"),
                      ),
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
                        value: perssoasEntrevistadasController.text.isNotEmpty
                            ? perssoasEntrevistadasController.text
                            : null,
                        hint: const Text('Select persona'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Select persona';
                          }
                          return null;
                        },
                        items: listOfPessoasEntrevistadas.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            perssoasEntrevistadasController.text = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      if (perssoasEntrevistadasController.text ==
                          'Director') ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Numero TEL:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: nommePersssoasEntreviController,
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
                                hintText: 'Entra numero de perssoa',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entra nomme de perssoa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Nomes:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: numeroPersssoasEntreviController,
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
                                hintText: 'Entra Nomes de perssoa',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entra numero de perssoa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                      if (perssoasEntrevistadasController.text == 'RAS') ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Numero TEL:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: nommePersssoasEntreviController,
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
                                hintText: 'Entra numero de perssoa',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entra nomme de perssoa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Nomes:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: numeroPersssoasEntreviController,
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
                                hintText: 'Entra Nomes de perssoa',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entra numero de perssoa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                      if (perssoasEntrevistadasController.text ==
                          'Chefe do centro') ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Numero TEL:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: nommePersssoasEntreviController,
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
                                hintText: 'Entra numero de perssoa',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entra nomme de perssoa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Nomes:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: numeroPersssoasEntreviController,
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
                                hintText: 'Entra Nomes de perssoa',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entra numero de perssoa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                      if (perssoasEntrevistadasController.text == 'PF PAV') ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Numero TEL:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: nommePersssoasEntreviController,
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
                                hintText: 'Entra numero de perssoa',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entra nomme de perssoa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Nomes:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: numeroPersssoasEntreviController,
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
                                hintText: 'Entra Nomes de perssoa',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entra numero de perssoa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                      if (perssoasEntrevistadasController.text == 'Outros') ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Numero TEL:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: nommePersssoasEntreviController,
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
                                hintText: 'Entra numero de perssoa',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entra nomme de perssoa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Nomes:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: numeroPersssoasEntreviController,
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
                                hintText: 'Entra Nomes de perssoa',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entra numero de perssoa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),

                ///--------- STEPPER 2-----------//////
                Step(
                  title: const Text(
                    "Enquadramento da vacinação, planeamento e aspectos gerais do serviço PAV no Centro de Saude. Responder apenas uma vez por cada Centro de Saude visitado. Esta parte só se aplica se a sessão tiver lugar num posto de estratégia avançada e não no centro de saúde.",
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "A sala de espera é confortável, nao exposto ao sol, chuvas e se encontra limpio",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question1Controller.text.isNotEmpty
                            ? Question1Controller.text
                            : null,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            // _selectedItem = newValue;
                            Question1Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Existe uma mesa e uma cadeira para o agente de saúde ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question2Controller.text.isNotEmpty
                            ? Question2Controller.text
                            : null,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            // _selectedItem = newValue;
                            Question2Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Existem casas de banho para as mães no centro de saudel ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question3Controller.text.isNotEmpty
                            ? Question3Controller.text
                            : null,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            // _selectedItem = newValue;
                            Question3Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Existe uma televisão ou um ecrã de projeção ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question4Controller.text.isNotEmpty
                            ? Question4Controller.text
                            : null,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            //_selectedItem = newValue;
                            Question4Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Existe um caixote do lixo ao alcance do responsável pela vacinaçã ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question5Controller.text.isNotEmpty
                            ? Question5Controller.text
                            : null,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question5Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "O calendário de vacinação de rotina está fixado na parede ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question6Controller.text.isNotEmpty
                            ? Question6Controller.text
                            : null,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question6Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Existe um mapa da área sanitaria fixado na parede ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question7Controller.text.isNotEmpty
                            ? Question7Controller.text
                            : null,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question7Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Existem cartazes sobre PAV de rotina  no sítio ou Centro de Saude ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question8Controller.text.isNotEmpty
                            ? Question8Controller.text
                            : null,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question8Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "O serviço dispõe de um álbum seriado sobre a vacinação ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Selecione uma resposta';
                        //   }
                        //   return null;
                        // },
                        value: Question9Controller.text.isNotEmpty
                            ? Question9Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question9Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "O Centro de Saude dispõe de um megafone ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Selecione uma resposta';
                        //   }
                        //   return null;
                        // },
                        value: Question10Controller.text.isNotEmpty
                            ? Question10Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question10Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),

                ///--------- STEPPER 3-----------//////
                Step(
                  title: const Text(
                    "Observe como o Agente de vacinacao atendeu as primeiras 5 mães seguidas durante a sessão e responda às seguintes perguntas.",
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Existe um sistema de triagem ou de ordenação das mães e das crianças em função da sua chegada ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question11Controller.text.isNotEmpty
                            ? Question11Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question11Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Falou que vacinas são administradas nesse dia ?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question12Controller.text.isNotEmpty
                            ? Question12Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question12Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Informou sobre possíveis efeitos secundários?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question13Controller.text.isNotEmpty
                            ? Question13Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question13Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Indicou quando é que a criança deve regressar e regista a data (no cartão de vacinacao da criança)?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question14Controller.text.isNotEmpty
                            ? Question14Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question14Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Aconselhou as maes e tutoras da criança a trazer sempre o cartão de vacinacao da criança?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question15Controller.text.isNotEmpty
                            ? Question15Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question15Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Convidou as maes e tutoras da criança a fazer perguntas?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question16Controller.text.isNotEmpty
                            ? Question16Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question16Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Existe o Gel de desinfeção des mãos no sitio da vacinação?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question17Controller.text.isNotEmpty
                            ? Question17Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question17Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Desinfecta as mãos  depois de cada ato de vacinação?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question18Controller.text.isNotEmpty
                            ? Question18Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question18Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "O vacinador foi simpático (cumprimentou, sorriu, despediu-se)?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question19Controller.text.isNotEmpty
                            ? Question19Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question19Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "O vacinador explicou das vacinas administradas e das doenças que cobrem?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question20Controller.text.isNotEmpty
                            ? Question20Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question20Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "O vacinador perguntou à mãe se ela tinha alguma dúvida?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question21Controller.text.isNotEmpty
                            ? Question21Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question21Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "O vacinador ouviu as preocupações e os receios da mãe e respondeu-lhe com ponderação?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question22Controller.text.isNotEmpty
                            ? Question22Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question22Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "O vacinador agradeceu e/ou felicitou a mãe?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question23Controller.text.isNotEmpty
                            ? Question23Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question23Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "O vacinador não se apressou no seu trabalho?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question24Controller.text.isNotEmpty
                            ? Question24Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question24Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Quanto tempo é que o vacinador passou a falar com o prestador de cuidados?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question25Controller.text.isNotEmpty
                            ? Question25Controller.text
                            : null,
                        items: listOfTiempoMinuto.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question25Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Quanto tempo é que a mãe esperou para ser atendida?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question26Controller.text.isNotEmpty
                            ? Question26Controller.text
                            : null,
                        items: listOfTiempoHora.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question26Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Houve alguma sessão educativa durante esta vacinação?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question27Controller.text.isNotEmpty
                            ? Question27Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question27Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Adoptou uma postura académica adequada?\nO animador põe os participantes à vontade: conta uma história engraçada, dança, etc.?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question28Controller.text.isNotEmpty
                            ? Question28Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question28Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "O conteúdo foi desenvolvido: história real, utilização de recursos visuais?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question29Controller.text.isNotEmpty
                            ? Question29Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question29Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Discutiu com os participantes, tendo em conta as suas preocupações, respondendo às perguntas com cortesia?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButtonFormField<String>(
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
                            borderSide: const BorderSide(
                                width: 1, color: Defaults.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'selecione uma resposta',
                        ),
                        value: Question30Controller.text.isNotEmpty
                            ? Question30Controller.text
                            : null,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question30Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2
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

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
