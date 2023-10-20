// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';

class QuestionarioDeObservacaoPage extends StatefulWidget {
  const QuestionarioDeObservacaoPage({super.key});

  @override
  State<QuestionarioDeObservacaoPage> createState() =>
      _QuestionarioDeObservacaoPageState();
}

class _QuestionarioDeObservacaoPageState
    extends State<QuestionarioDeObservacaoPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  String selectedRegiao = ''; // Région par défaut
  String selectedAreas = ''; // Ville par défaut
  String selectedOption = '';
  String? _selectedItem;
  Map<String, List<String>> regionCities = {
    'BAFATA-BIJAGOS': ['Bafata', 'Bambadinca', 'Contuboel', 'Cosse', 'Xitole'],
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

  ///--------- STEPPER 1 ------------/////
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

  @override
  void initState() {
    super.initState();
    regiaoController = TextEditingController(text: selectedRegiao);
    areaDaSanitariaController = TextEditingController(text: selectedAreas);
  }

  @override
  void dispose() {
    regiaoController.dispose();
    areaDaSanitariaController.dispose();
    super.dispose();
  }

  void updateCityList() {
    setState(() {
      selectedRegiao = regiaoController.text;
      selectedAreas = areaDaSanitariaController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                '',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '',
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
                            ///_submitTransfer();
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
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Select Sanitaria';
                          //   }
                          //   return null;
                          // },
                          items: regionCities.keys.map((String region) {
                            return DropdownMenuItem<String>(
                              value: region,
                              child: Text(region),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              regiaoController.text = newValue!;
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
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Select Sanitaria';
                          //   }
                          //   return null;
                          // },
                          items:
                              regionCities[selectedRegiao]?.map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              areaDaSanitariaController.text = newValue!;
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
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Select persona';
                        //   }
                        //   return null;
                        // },
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
                                hintText: 'Entra nomme de perssoa',
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Entra nomme de perssoa';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
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
                                hintText: 'Entra numero de perssoa',
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Entra numero de perssoa';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                      ],
                      if (perssoasEntrevistadasController.text == 'RAS') ...[
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
                                hintText: 'Entra nomme de perssoa',
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Entra nomme de perssoa';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
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
                                hintText: 'Entra numero de perssoa',
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Entra numero de perssoa';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                      ],
                      if (perssoasEntrevistadasController.text ==
                          'Chefe do centro') ...[
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
                                hintText: 'Entra nomme de perssoa',
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Entra nomme de perssoa';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
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
                                hintText: 'Entra numero de perssoa',
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Entra numero de perssoa';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                      ],
                      if (perssoasEntrevistadasController.text == 'PF PAV') ...[
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
                                hintText: 'Entra nomme de perssoa',
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Entra nomme de perssoa';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
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
                                hintText: 'Entra numero de perssoa',
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Entra numero de perssoa';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                      ],
                      if (perssoasEntrevistadasController.text == 'Outros') ...[
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
                                hintText: 'Entra nomme de perssoa',
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Entra nomme de perssoa';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
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
                                hintText: 'Entra numero de perssoa',
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Entra numero de perssoa';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfResponses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
                            Question10Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfTiempoMinuto.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfTiempoHora.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
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
                      DropdownButton<String>(
                        value: _selectedItem,
                        items: listOfSimNao.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
                            Question30Controller.text =
                                newValue!; // Mettre à jour le contrôleur
                          });
                        },
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2
                      ? StepState.complete
                      : StepState.disabled,
                ),

                ///--------- STEPPER 4-----------//////
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
  // var resultSearchDocument = '';
  // continued() {
  //   if (_currentStep == 0) {
  //     _submitForm(token).then((value) {
  //       if (value == 0) {
  //         //// NOT FOUND
  //         setState(() {
  //           _currentStep;
  //           resultSearchDocument = 'Document Not Found';
  //         });
  //       } else if (value == -1) {
  //         /// ERROR IN THE APP
  //         setState(() {
  //           _currentStep;
  //           resultSearchDocument = 'Problem occurs during search';
  //         });
  //       } else {
  //         //SUCCESS
  //         _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  //         resultSearchDocument = '';
  //       }
  //     });
  //   } else {
  //     _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  //   }
  // }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
