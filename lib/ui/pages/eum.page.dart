// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/db/local.servie.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/surveyExtraction.dart';
import 'package:unicefapp/ui/pages/EUM/Questionario.de.observa%C3%A7ao.details.dart';
import 'package:unicefapp/ui/pages/eum.details.page.dart';
import 'package:unicefapp/ui/pages/EUM/eumD.page.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EUMPage extends StatefulWidget {
  const EUMPage({super.key});

  @override
  State<EUMPage> createState() => _EUMPageState();
}

class _EUMPageState extends State<EUMPage> {
  List<DTOSurveyExtration> tableData = [];
  final storage = locator<TokenStorageService>();
  final dbHandler = locator<LocalService>();
  late final Future<Agent?> _futureAgentConnected;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) => _getEumList(value!.id));
    // DTOSurveyExtration s1 = DTOSurveyExtration(
    //     survey_completed_id: "",
    //     survey_id: "6502ff34b77c766d78c65c9c",
    //     title: "VACINACAO CONTRA COVID-19 NA GUINE-BISSAU 2023",
    //     category: "SBC",
    //     status: "ONGOING");
    // tableData.add(s1);
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  void readAllSurvey() async {
    List<Map<String, dynamic>> list = await dbHandler.readAllSurvey();

    try {
      if (list.isEmpty) {
        // Affiche un message d'erreur si la liste est vide
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'INFORMAÇAO',
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
                    'Nao has dados',
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
                child: const Text('Tenta de novo'),
              ),
            ],
          ),
        );
      } else {
        var response = await http.post(
          Uri.parse('https://www.trackiteum.org/u/admin/offline/eum/save'),
          body: jsonEncode(list),
          headers: {
            "Content-type": "application/json",
          },
        );
        if (response.statusCode == 200) {
          await dbHandler.deleteAllEum();

          // Affiche un message de succès si l'envoi est réussi
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
                      'Dados enviado com sucesso',
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
                  child: const Text('VOLTAR'),
                ),
              ],
            ),
          );
        } else {
          // Affiche un message d'erreur si l'envoi échoue
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'ERRO',
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
                      'Erro occoreu durante a dados',
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
                  child: const Text('Tenta de novo'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _getEumList(String userId) async {
    // try {
    var response = await http.get(
        Uri.parse('https://www.trackiteum.org/u/admin/eum/$userId'),
        headers: {
          "Content-type": "application/json",
        });
    print(response.body);
    print('HTTP-------- https://www.trackiteum.org/u/admin/eum/$userId');
    if (response.statusCode == 200) {
      // LoadingIndicatorDialog().show(context);
      Iterable jsonResponse = json.decode(response.body);
      var apiResponse = List<DTOSurveyExtration>.from(
          jsonResponse.map((e) => DTOSurveyExtration.fromJson(e)).toList());
      setState(() {
        // LoadingIndicatorDialog().dismiss();
        tableData = apiResponse;
      });
    } else {
      // setState(() {
      //   apiResult = 'Erreur lors de l\'appel à l\'API.';
      // });
      print(response.body);
    }
    // } on DioError catch (e) {
    //   LoadingIndicatorDialog().dismiss();
    //   ErrorDialog().show(e);
    // }
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
                'EUM',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'End User Monitoring',
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
      drawer: const MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: DataTable(
                      horizontalMargin: 40,
                      dividerThickness: 2,
                      dataRowHeight: 50,
                      showBottomBorder: true,
                      headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Defaults.bluePrincipal),
                      headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => Defaults.white),
                      columns: const [
                        DataColumn(label: Text('Title')),
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: tableData.map((data) {
                        return DataRow(
                            onLongPress: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EUMDetailsPage(
                                            dtoSurveyExtration: data,
                                          )));
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => EUMDetailsPage1(
                              //               dtoSurveyExtration: data,
                              //             )));
                            },
                            cells: [
                              DataCell(Text(data.title)),
                              DataCell(Text(data.category)),
                              DataCell(Text(data.status)),
                            ]);
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: readAllSurvey, child: Text('Transférer')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    // onPressed: _submitForm,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QuestionarioDeObservacaoPage()),
                      );
                    },
                    child: Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
