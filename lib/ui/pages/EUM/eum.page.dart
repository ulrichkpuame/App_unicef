// ignore_for_file: deprecated_member_use

/*import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unicefapp/_api/apiService.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/db/local.servie.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/appsurveyextraction.dart';
import 'package:unicefapp/models/dto/genericDocument.dart';
import 'package:unicefapp/models/dto/surveyCreation.dart';
import 'package:unicefapp/models/dto/surveyExtraction.dart';
import 'package:unicefapp/models/dto/surveyPage.dart';
import 'package:unicefapp/models/dto/surveyQuestion.dart';
import 'package:unicefapp/ui/pages/EUM/Questionario.de.observa%C3%A7ao.details.dart';
import 'package:unicefapp/ui/pages/EUM/Questionario.para.chefe.dart';
import 'package:unicefapp/ui/pages/EUM/Questionario.sobre.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/error.dialog.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';
import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EUMPage extends StatefulWidget {
  const EUMPage({super.key});

  @override
  State<EUMPage> createState() => _EUMPageState();
}

class _EUMPageState extends State<EUMPage> {
  List<DTOSurveyExtration> tableData = [];
  final storage = locator<TokenStorageService>();
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  late final Future<Agent?> _futureAgentConnected;
  String usercountry = '';

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    // _futureAgentConnected.then((value) => _getEumList(value!.id));

    getAgent().then((value) => usercountry = value!.country);
    /*DTOSurveyExtration s1 = DTOSurveyExtration(
        survey_completed_id: "",
        survey_id: "6502ff34b77c766d78c65c9d",
        title: "Questionário de observação",
        category: "QO",
        status: "ONGOING");
    tableData.add(s1);
    DTOSurveyExtration s2 = DTOSurveyExtration(
        survey_completed_id: "",
        survey_id: "6502ff34b77c766d78c65c9e",
        title: "Questionário RAS",
        category: "QRAS",
        status: "ONGOING");
    tableData.add(s2);
    DTOSurveyExtration s3 = DTOSurveyExtration(
        survey_completed_id: "",
        survey_id: "6502ff34b77c766d78c65c9f",
        title: "Questionário Plano",
        category: "QPLANO",
        status: "ONGOING");
    tableData.add(s3);*/
    super.initState();
  }

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

  void sendAllSurvey() async {
    List<Map<String, dynamic>> list = await dbHandler.readAllSurvey();

    try {
      if (list.isEmpty) {
        // Affiche un message d'erreur si la liste est vide
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.info,
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
                  Text(
                    AppLocalizations.of(context)!.nodata,
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
      } else {
        var response = await http.post(
          Uri.parse('https://www.trackiteum.org/u/admin/offline/eum/save'),
          body: jsonEncode(list),
          headers: {
            "Content-type": "application/json",
          },
        );
        if (response.statusCode == 200) {
          // Affiche un message de succès si l'envoi est réussi
          // ignore: use_build_context_synchronously
          showDialog(
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
                      AppLocalizations.of(context)!.eumSendMsg,
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
                  child: Text(AppLocalizations.of(context)!.goBack),
                ),
              ],
            ),
          );

          await dbHandler.deleteAllEum();
        } else {
          // Affiche un message d'erreur si l'envoi échoue
          // ignore: use_build_context_synchronously
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
                      'animations/error-dialog.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    Text(
                      AppLocalizations.of(context)!.eumErroMsg,
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
      }
    } on DioError catch (e) {
      LoadingIndicatorDialog().dismiss();
      ErrorDialog().show(e);
    }
  }

  Future<void> fetchDataAndSaveToDatabase() async {
    var url = Uri.parse('http://192.168.1.10:8094/u/activeSurveys');
    LoadingIndicatorDialog().show(context);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (final surveyData in data) {
          final SurveyCreation survey = SurveyCreation.fromJson(surveyData);

          if (survey.page != null) {
            await dbHandler.saveSurveyCreation(survey);

            for (final pageData in survey.page!) {
              if (pageData is Map<String, dynamic>) {
                final SurveyPage page = SurveyPage.fromJson(pageData.toJson());
                await dbHandler.saveSurveyPage(page);

                if (page.questions != null) {
                  for (final questionData in page.questions!) {
                    if (questionData is Map<String, dynamic>) {
                      final SurveyQuestion question =
                          SurveyQuestion.fromJson(questionData.toJson());
                      await dbHandler.saveSurveyQuestion(question);
                    }
                  }
                }
              }
            }
          }
        }

        LoadingIndicatorDialog().dismiss();

        // ignore: use_build_context_synchronously
        showDialog(
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
                    AppLocalizations.of(context)!.surveyDownloaded,
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
                  child: Text(AppLocalizations.of(context)!.goBack))
            ],
          ),
        );
      } else {
        LoadingIndicatorDialog().dismiss();

        // ignore: use_build_context_synchronously
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
                      AppLocalizations.of(context)!.surveyNoDownloaded,
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
    } on DioError catch (e) {
      LoadingIndicatorDialog().dismiss();
      ErrorDialog().show(e);
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
                      MaterialPageRoute(builder: (context) => const HomePage()),
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
                AppLocalizations.of(context)!.eumTitle,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.eumSubTitle,
                style: const TextStyle(
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
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DataTable(
                        horizontalMargin: 20,
                        dividerThickness: 4,
                        dataRowHeight: 60,
                        showBottomBorder: true,
                        headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Defaults.bluePrincipal),
                        headingRowColor: MaterialStateProperty.resolveWith(
                            (states) => Defaults.white),
                        columns: [
                          DataColumn(
                              label: Text(AppLocalizations.of(context)!.title)),
                          DataColumn(
                              label:
                                  Text(AppLocalizations.of(context)!.category)),
                          DataColumn(
                              label:
                                  Text(AppLocalizations.of(context)!.status)),
                        ],
                        rows: tableData.asMap().entries.map((entry) {
                          int index = entry.key;
                          DTOSurveyExtration data = entry.value;
                          return DataRow(
                            onSelectChanged: (bool? selected) {
                              if (selected != null && selected) {
                                if (index == 0) {
                                  // Ouvrez la page QuestionarioDeObservacaoPage pour la ligne 1
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          QuestionarioDeObservacaoPage(
                                        dtoSurveyExtration: data,
                                      ),
                                    ),
                                  );
                                } else if (index == 1) {
                                  // Ouvrez la page EUMDetailsPage1 pour la ligne 2
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          QuestionarioParaChefesPage(
                                        dtoSurveyExtration: data,
                                      ),
                                    ),
                                  );
                                } else if (index == 2) {
                                  // Ouvrez la page EUMDetailsPage1 pour la ligne 2
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          QuestionarioSobrePage(
                                        dtoSurveyExtration: data,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            cells: [
                              DataCell(
                                Text(
                                  data.title,
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              DataCell(Text(data.category)),
                              DataCell(Text(data.status)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: sendAllSurvey,
                      child: Text(AppLocalizations.of(context)!.transferer)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: fetchDataAndSaveToDatabase,
                      child: Text(AppLocalizations.of(context)!.download)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
