import 'dart:collection';
import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
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
import 'package:http/http.dart' as http;
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';

class QuestionarioParaChefesPage extends StatefulWidget {
  const QuestionarioParaChefesPage(
      {super.key, required this.dtoSurveyExtration});

  final DTOSurveyExtration dtoSurveyExtration;
  @override
  State<QuestionarioParaChefesPage> createState() =>
      _QuestionarioParaChefesPageState();
}

class _QuestionarioParaChefesPageState
    extends State<QuestionarioParaChefesPage> {
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

  List<String> listOfNumber = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "+",
  ];

  List<String> listOfSelectedMultipleQuestion4 = [
    "PAV",
    "Maternidade",
    "Pediatria",
    "CPN",
    "Laboratorio",
    "Todos",
    "Outros",
  ];
  final List<String> _selectedMultipleQuestion4 = [];

  List<String> listOfSelectedMultipleQuestion7 = [
    "Caixa isotérmica",
    "Conservador",
    "Frigorifico",
    "Porta-vacinas",
    "Outros (especificar)",
  ];
  final List<String> _selectedMultipleQuestion7 = [];

  List<String> listOfSelectedMultipleQuestion9 = [
    "Folheto",
    "Cartaz",
    "Album Seriado",
    "Megafone",
    "Roll-up",
    "Outro",
    "Nenhum",
  ];
  final List<String> _selectedMultipleQuestion9 = [];

  List<String> listOfSelectedMultipleQuestion10 = [
    "Receção",
    "Sessão avançada",
    "CNP",
    "Maternidade",
    "Outra (especificar)",
  ];
  final List<String> _selectedMultipleQuestion10 = [];

  List<String> listOfSelectedMultipleQuestion11 = [
    "Mercado (Lumo)",
    "Igreja/Mesquita",
    "Cerimónia de Fanado",
    "Chefia",
    "Associação",
    "Outro (especificar)",
  ];
  final List<String> _selectedMultipleQuestion11 = [];

  List<String> listOfSelectedMultipleQuestion12 = [
    "BCG",
    "VOP",
    "Penta",
    "PCV13",
    "Rota",
    "VPI",
    "Sarampo",
    "VAA",
    "Covid-19",
    "Vitamina A",
    "Nenhuma",
  ];
  final List<String> _selectedMultipleQuestion12 = [];
  final List<String> _selectedMultipleQuestion13 = [];

  List<String> listOfSelectedMultipleQuestion14 = [
    "Conversas educativas (CE)",
    "No seu centro de saúde",
    "CE durante estratégias avançadas",
    "Visita domiciliária",
    "Sensibilização de populações especiais",
    "Mobilização de recursos",
    "Nenhuma",
    "Outra (especificar)",
  ];
  final List<String> _selectedMultipleQuestion14 = [];

  List<String> listOfSelectedMultipleQuestion15 = [
    "ACS",
    "Rádios",
    "Djarga",
    "Autoridade administrativa",
    "Curandeiros tradicionais",
    "Comunicadores tradicionais",
    "Outros (especificar)",
  ];
  final List<String> _selectedMultipleQuestion15 = [];

  List<String> listOfSelectedMultipleQuestion16 = [
    "Edu. Sanit. Fixa",
    "Edu. Sanit. Avanç",
    "Visita domiciliária",
    "Reunião de advocacia",
    "Rádio",
    "Igreja/Mesquita",
    "Lumo",
    "Outros (especificar)",
  ];
  final List<String> _selectedMultipleQuestion16 = [];

  List<String> listOfQuestion17 = [
    "CIP",
    "CREC",
    "SBC",
    "Mobilizacao em saude comunitaria",
    "Vacinacao",
    "Outro",
  ];

  List<String> listOfEscolaUnica = [
    "Tuberculose",
    "Sarampo",
    "Difteria",
    "Tétano",
    "Tosse convulsa",
    "Hepatite viral B",
    "Poliomielite",
    "Febre amarela",
    "Pneumonia",
    "Meningite",
    "Covid-19",
    "Diarreia por rotavírus",
    "Deficiência de vitamina A",
    "Nenhuma",
  ];

  List<String> listOfQuestion5 = [
    "Sim",
    "Não",
    "Nunca ouvi",
  ];

  List<String> listOfQuestion8 = [
    "RAS",
    "PF PAV",
    "Parteira",
    "SOT",
    "ACS",
    "Associação",
    "Outro",
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
  TextEditingController Question11Controller = TextEditingController();
  TextEditingController Question12Controller = TextEditingController();
  TextEditingController Question13Controller = TextEditingController();
  TextEditingController Question14Controller = TextEditingController();
  TextEditingController Question15Controller = TextEditingController();
  TextEditingController Question16Controller = TextEditingController();
  TextEditingController Question17Controller = TextEditingController();
  TextEditingController Question18Controller = TextEditingController();

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
                "Quantos profissionais de saúde trabalham no seu centro de saúde?",
            response: Question1Controller.text);
        SurveyQuestionResponse surveyQuestionResponse9 = SurveyQuestionResponse(
            questionid: 9,
            question: "Qual o número de ASC activos na sua área de sanitaria?",
            response: Question2Controller.text);
        SurveyQuestionResponse surveyQuestionResponse10 =
            SurveyQuestionResponse(
                questionid: 10,
                question: "Quantas ASC são mulheres?",
                response: Question3Controller.text);
        SurveyQuestionResponse surveyQuestionResponse11 = SurveyQuestionResponse(
            questionid: 11,
            question:
                "Que serviços estão disponíveis no seu Centro de Saude (Escolha múltipla )",
            response: _selectedMultipleQuestion4.join(', '));
        SurveyQuestionResponse surveyQuestionResponse12 = SurveyQuestionResponse(
            questionid: 12,
            question:
                "Já ouviu falar do Plano Estratégico de Comunicação do PAV 2018-2022?",
            response: Question5Controller.text);
        SurveyQuestionResponse surveyQuestionResponse13 = SurveyQuestionResponse(
            questionid: 13,
            question:
                "Quantas tabancas e ou bairros que a sua Area Sanitaria cobre ?",
            response: Question6Controller.text);
        SurveyQuestionResponse surveyQuestionResponse14 = SurveyQuestionResponse(
            questionid: 14,
            question:
                "De que equipamento dispõe o seu centro de saúde para armazenar e transportar as vacinas?  (Escolha múltipla )",
            response: _selectedMultipleQuestion7.join(', '));
        SurveyQuestionResponse surveyQuestionResponse15 = SurveyQuestionResponse(
            questionid: 15,
            question:
                "Quem habitualmente faz a comunicacao sobre a vacinação durante as sessões? Uma opção",
            response: Question8Controller.text);
        SurveyQuestionResponse surveyQuestionResponse16 = SurveyQuestionResponse(
            questionid: 16,
            question:
                "Quais os materiais estão disponíveis no centro de saúde para apoiar as actividades de comunicação? (Escolha múltipla )",
            response: _selectedMultipleQuestion9.join(', '));
        SurveyQuestionResponse surveyQuestionResponse17 = SurveyQuestionResponse(
            questionid: 17,
            question:
                "Em que ocasiões é que comunica sobre a vacinação no Centro de Saúde? (Escolha múltipla )	",
            response: _selectedMultipleQuestion10.join(', '));
        SurveyQuestionResponse surveyQuestionResponse18 = SurveyQuestionResponse(
            questionid: 18,
            question:
                "Em que ocasiões é que comunica sobre a vacinação na comunidade?	(Escolha múltipla )",
            response: _selectedMultipleQuestion11.join(', '));
        SurveyQuestionResponse surveyQuestionResponse19 = SurveyQuestionResponse(
            questionid: 19,
            question:
                "Para quais das seguintes vacinas/insumos tem mais dificuldade em comunicar? (Citar 02)",
            response: _selectedMultipleQuestion12.join(', '));
        SurveyQuestionResponse surveyQuestionResponse20 = SurveyQuestionResponse(
            questionid: 20,
            question:
                "Para qual das seguintes doenças tem mais dificuldade em comunicar?   (Escolha unica )",
            response: _selectedMultipleQuestion13.join(', '));
        SurveyQuestionResponse surveyQuestionResponse21 = SurveyQuestionResponse(
            questionid: 21,
            question:
                "Qual das seguintes 3 actividades considera mais difícil de implementar no seu contexto? Citar 03",
            response: _selectedMultipleQuestion14.join(', '));
        SurveyQuestionResponse surveyQuestionResponse22 = SurveyQuestionResponse(
            questionid: 22,
            question:
                "Qual das seguintes canais de comunicacao com a comunidade é mais eficaz na promoção da vacinação? Citar 02",
            response: _selectedMultipleQuestion15.join(', '));
        SurveyQuestionResponse surveyQuestionResponse23 = SurveyQuestionResponse(
            questionid: 23,
            question:
                "Na sua opinião, que actividades de comunicação devem ser realçadas na sua área de intervenção para aumentar o apoio dos pais às vacinas e à imunização? Citar 02",
            response: _selectedMultipleQuestion16.join(', '));
        SurveyQuestionResponse surveyQuestionResponse24 = SurveyQuestionResponse(
            questionid: 24,
            question:
                "Quais são as suas necessidades e expectativas em termos de formação para melhorar as suas actividades de comunicação sobre vacinação?",
            response: Question17Controller.text);
        SurveyQuestionResponse surveyQuestionResponse25 = SurveyQuestionResponse(
            questionid: 25,
            question:
                "Com base na sua experiência, qual é uma boa prática de comunicação sobre vacinação que tenha implementado no seu centro de saúde e que possa partilhar com os seus pares?",
            response: Question18Controller.text);

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
    Question11Controller.dispose();
    Question12Controller.dispose();
    Question13Controller.dispose();
    Question14Controller.dispose();
    Question15Controller.dispose();
    Question16Controller.dispose();
    Question17Controller.dispose();
    Question18Controller.dispose();

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
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Questionário RAS',
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
                    ] else if (_currentStep == 1) ...[
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
                    "Questionario do Investigadore",
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    children: [
                      ///-----------QUESTION 1-------/////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q1: Quantos profissionais de saúde trabalham no seu centro de saúde?",
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
                        items: listOfNumber.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Question1Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),

                      ////////------QUESTION 2------///////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "Q2: Qual o número de ASC activos na sua área de sanitaria?"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ZoneSaisie(context, Question2Controller),
                      ),

                      ////////------QUESTION 3------///////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Q3: Quantas ASC são mulheres?"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ZoneSaisie(context, Question3Controller),
                      ),

                      ////////------QUESTION 4------///////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "Q4: Que serviços estão disponíveis no seu Centro de Saude (Escolha múltipla )"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha múltipla',
                          ),
                          isExpanded: true,
                          value: Question4Controller.text.isNotEmpty
                              ? Question4Controller.text
                              : null,
                          items: listOfSelectedMultipleQuestion4.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (_selectedMultipleQuestion4.contains(value!
                                    .split('@')
                                    .elementAt(0)
                                    .toString())) {
                                  _selectedMultipleQuestion4.remove(value);
                                } else {
                                  _selectedMultipleQuestion4.add(value!);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Éléments sélectionnés: ${_selectedMultipleQuestion4.join(', ')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ///////------QUESTION 5---------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q5: Já ouviu falar do Plano Estratégico de Comunicação do PAV 2018-2022?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'selecione uma resposta',
                          ),
                          value: Question5Controller.text.isNotEmpty
                              ? Question5Controller.text
                              : null,
                          items: listOfQuestion5.map((String item) {
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
                      ),

                      ////////------QUESTION 6------///////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "Q6: Quantas tabancas e ou bairros que a sua Area Sanitaria cobre ?"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ZoneSaisie(context, Question6Controller),
                      ),

                      ///////------QUESTION 7---------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q7: De que equipamento dispõe o seu centro de saúde para armazenar e transportar as vacinas?  (Escolha múltipla )",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha múltipla',
                          ),
                          isExpanded: true,
                          value: Question7Controller.text.isNotEmpty
                              ? Question7Controller.text
                              : null,
                          items: listOfSelectedMultipleQuestion7.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (_selectedMultipleQuestion7.contains(value!
                                    .split('@')
                                    .elementAt(0)
                                    .toString())) {
                                  _selectedMultipleQuestion7.remove(value);
                                } else {
                                  _selectedMultipleQuestion7.add(value!);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Itens selecionados: ${_selectedMultipleQuestion7.join(', ')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ///////-------QUESTION 8--------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q8: Quem habitualmente faz a comunicacao sobre a vacinação durante as sessões? Uma opção",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'selecione uma opção',
                          ),
                          value: Question8Controller.text.isNotEmpty
                              ? Question8Controller.text
                              : null,
                          items: listOfQuestion8.map((String item) {
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
                      ),

                      ///////-------QUESTION 9--------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q9: Quais os materiais estão disponíveis no centro de saúde para apoiar as actividades de comunicação? (Escolha múltipla )",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha múltipla',
                          ),
                          isExpanded: true,
                          value: Question9Controller.text.isNotEmpty
                              ? Question9Controller.text
                              : null,
                          items: listOfSelectedMultipleQuestion9.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (_selectedMultipleQuestion9.contains(value!
                                    .split('@')
                                    .elementAt(0)
                                    .toString())) {
                                  _selectedMultipleQuestion9.remove(value);
                                } else {
                                  _selectedMultipleQuestion9.add(value);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Itens selecionados: ${_selectedMultipleQuestion9.join(', ')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ///////------QUESTION 10---------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q10: Em que ocasiões é que comunica sobre a vacinação no Centro de Saúde? (Escolha múltipla)",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha múltipla',
                          ),
                          isExpanded: true,
                          value: Question10Controller.text.isNotEmpty
                              ? Question10Controller.text
                              : null,
                          items: listOfSelectedMultipleQuestion10.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (_selectedMultipleQuestion10.contains(value!
                                    .split('@')
                                    .elementAt(0)
                                    .toString())) {
                                  _selectedMultipleQuestion10.remove(value);
                                } else {
                                  _selectedMultipleQuestion10.add(value);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Itens selecionados: ${_selectedMultipleQuestion10.join(', ')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ///////-------QUESTION 11--------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q11: Em que ocasiões é que comunica sobre a vacinação no Centro de Comunidade? (Escolha múltipla)",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha múltipla',
                          ),
                          isExpanded: true,
                          value: Question11Controller.text.isNotEmpty
                              ? Question11Controller.text
                              : null,
                          items: listOfSelectedMultipleQuestion11.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (_selectedMultipleQuestion11.contains(value!
                                    .split('@')
                                    .elementAt(0)
                                    .toString())) {
                                  _selectedMultipleQuestion11.remove(value);
                                } else {
                                  _selectedMultipleQuestion11.add(value);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Itens selecionados: ${_selectedMultipleQuestion11.join(', ')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ///////--------QUESTION 12-------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q12: Para quais das seguintes vacinas/insumos tem mais dificuldade em comunicar? (Citar 02)",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha múltipla',
                          ),
                          isExpanded: true,
                          value: Question12Controller.text.isNotEmpty
                              ? Question12Controller.text
                              : null,
                          items: listOfSelectedMultipleQuestion12.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (_selectedMultipleQuestion12.contains(value!
                                    .split('@')
                                    .elementAt(0)
                                    .toString())) {
                                  _selectedMultipleQuestion12.remove(value);
                                } else {
                                  _selectedMultipleQuestion12.add(value);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Itens selecionados: ${_selectedMultipleQuestion12.join(', ')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ///////-------QUESTION 13--------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q13: Para qual das seguintes doenças tem mais dificuldade em comunicar?   (Escolha unica )",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha múltipla',
                          ),
                          isExpanded: true,
                          value: Question13Controller.text.isNotEmpty
                              ? Question13Controller.text
                              : null,
                          items: listOfEscolaUnica.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (_selectedMultipleQuestion13.contains(value!
                                    .split('@')
                                    .elementAt(0)
                                    .toString())) {
                                  _selectedMultipleQuestion13.remove(value);
                                } else {
                                  _selectedMultipleQuestion13.add(value);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Itens selecionados: ${_selectedMultipleQuestion13.join(', ')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ///////-------QUESTION 14--------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q14: Qual das seguintes 3 actividades considera mais difícil de implementar no seu contexto? Citar 03",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha múltipla',
                          ),
                          isExpanded: true,
                          value: Question14Controller.text.isNotEmpty
                              ? Question14Controller.text
                              : null,
                          items: listOfSelectedMultipleQuestion14.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (_selectedMultipleQuestion14.contains(value!
                                    .split('@')
                                    .elementAt(0)
                                    .toString())) {
                                  _selectedMultipleQuestion14.remove(value);
                                } else {
                                  _selectedMultipleQuestion14.add(value);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Itens selecionados: ${_selectedMultipleQuestion14.join(', ')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ///////-------QUESTION 15--------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q15: Qual das seguintes canais de comunicacao com a comunidade é mais eficaz na promoção da vacinação? Citar 02",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha múltipla',
                          ),
                          isExpanded: true,
                          value: Question15Controller.text.isNotEmpty
                              ? Question15Controller.text
                              : null,
                          items: listOfSelectedMultipleQuestion15.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (_selectedMultipleQuestion15.contains(value!
                                    .split('@')
                                    .elementAt(0)
                                    .toString())) {
                                  _selectedMultipleQuestion15.remove(value);
                                } else {
                                  _selectedMultipleQuestion15.add(value);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Itens selecionados: ${_selectedMultipleQuestion15.join(', ')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ///////--------QUESTION 16-------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q16: Na sua opinião, que actividades de comunicação devem ser realçadas na sua área de intervenção para aumentar o apoio dos pais às vacinas e à imunização? Citar 02",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha múltipla',
                          ),
                          value: Question16Controller.text.isNotEmpty
                              ? Question6Controller.text
                              : null,
                          items: listOfSelectedMultipleQuestion16.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (_selectedMultipleQuestion16.contains(value!
                                    .split('@')
                                    .elementAt(0)
                                    .toString())) {
                                  _selectedMultipleQuestion16.remove(value);
                                } else {
                                  _selectedMultipleQuestion16.add(value);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Itens selecionados: ${_selectedMultipleQuestion16.join(', ')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ///////-------QUESTION 17--------//////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Q17: Quais são as suas necessidades e expectativas em termos de formação para melhorar as suas actividades de comunicação sobre vacinação?",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
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
                            hintText: 'Escolha Unica',
                          ),
                          isExpanded: true,
                          value: Question17Controller.text.isNotEmpty
                              ? Question17Controller.text
                              : null,
                          items: listOfQuestion17.map((String item) {
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
                      ),

                      ////////-------QUESTION 18-----///////
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "Q18: Com base na sua experiência, qual é uma boa prática de comunicação sobre vacinação que tenha implementado no seu centro de saúde e que possa partilhar com os seus pares?"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ZoneSaisie(context, Question18Controller),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
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
