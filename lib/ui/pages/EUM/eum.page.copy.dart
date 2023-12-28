// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/apiService.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/db/local.servie.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/surveyCreation.dart';
import 'package:unicefapp/models/dto/surveyPage.dart';
import 'package:unicefapp/models/dto/surveyQuestion.dart';
import 'package:unicefapp/ui/pages/EUM/eum.details.page.copy.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/error.dialog.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';
import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity/connectivity.dart' as connectivity;

class EUMPageCopy extends StatefulWidget {
  const EUMPageCopy({super.key});

  @override
  State<EUMPageCopy> createState() => _EUMPageCopyState();
}

class _EUMPageCopyState extends State<EUMPageCopy> {
  final storage = locator<TokenStorageService>();
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  late final Future<Agent?> _futureAgentConnected;
  List<SurveyCreation>? tableData;
  String? usercountry = '';
  String? userId = '';
  String? selectedSurveyId;
  String BASEURL = 'http://192.168.1.4:8096';
  bool isConnected = false;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) {
      if (value != null) {
        setState(() {
          usercountry = value.country;
        });

        // Check for internet connectivity
        checkInternetConnectivity().then((isConnected) {
          if (isConnected) {
            // If connected, fetch data from the server
            fetchSurveysAndFillTable(usercountry!);
          } else {
            // If not connected, fetch data from local storage
            fetchSurveysFromLocal();
          }
        });
      }
    });

    super.initState();
  }

// Function pour vérifier la connexion internet
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult =
        await (connectivity.Connectivity().checkConnectivity());
    return connectivityResult == connectivity.ConnectivityResult.mobile ||
        connectivityResult == connectivity.ConnectivityResult.wifi;
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  //----------- CHARGE LES INFORMATIONS DE SURVEY --------------//
  Future<void> fetchSurveysAndFillTable(String country) async {
    String apiUrl =
        '$BASEURL/u/admin/allActiveCreatedSurveysPerCountry/$country';

    try {
      final response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        print('SUCCESS');
        final List<dynamic> data = response.data;
        List<SurveyCreation> surveys =
            data.map((json) => SurveyCreation.fromJson(json)).toList();

        // Effacez les données précédentes de la tableData
        setState(() {
          tableData = [];
        });

        // Ajoutez les nouvelles données à la tableData
        setState(() {
          tableData!.addAll(surveys);
        });

        // Affichez un message de succès ou effectuez d'autres actions si nécessaire
        // ...
      } else {
        print('ERROR');
        throw Exception('Failed to load surveys');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //  Appel de api pour telecharger tout les survey dispo
  Future<void> fetchDataAndSaveToDatabase() async {
    var url = Uri.parse(
        '$BASEURL/u/admin/allActiveCreatedSurveysPerCountry/$usercountry');
    LoadingIndicatorDialog().show(context);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = await jsonDecode(response.body);

        // Effacez les données précédentes de la tableData
        setState(() {
          tableData = [];
        });

        for (final surveyData in data) {
          final SurveyCreation survey = SurveyCreation.fromJson(surveyData);

          if (survey.page != null) {
            await dbHandler.saveSurveyCreation(survey);

            for (final pageData in survey.page!) {
              if (pageData is Map<String, dynamic>) {
                final SurveyPage page =
                    SurveyPage.fromJson(pageData as Map<String, dynamic>);
                await dbHandler.saveSurveyPage(page);

                if (page.questions != null) {
                  for (final questionData in page.questions!) {
                    if (questionData is Map<String, dynamic>) {
                      final SurveyQuestion question = SurveyQuestion.fromJson(
                          questionData as Map<String, dynamic>);
                      await dbHandler.saveSurveyQuestion(question);
                    }
                  }
                }
              }
            }

            // Ajoutez les données de surveyData à la tableData
            setState(() {
              tableData!.add(survey);
            });
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
                    Navigator.of(context).pop();
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

  //  Appel de api pour telecharger un seul survey
  Future<void> fetchDataAndSaveOneSurveyToDatabase() async {
    var url = Uri.parse(
        '$BASEURL/u/admin/SurveyByCountry/$usercountry/$selectedSurveyId');
    LoadingIndicatorDialog().show(context);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = await jsonDecode(response.body);

// Effacez les données précédentes de la tableData
        /*setState(() {
          tableData = [];
        });*/

        final SurveyCreation survey = SurveyCreation.fromJson(data);

        if (survey.page != null) {
          await dbHandler.saveSurveyCreation(survey);

          for (final pageData in survey.page!) {
            if (pageData is Map<String, dynamic>) {
              final SurveyPage page =
                  SurveyPage.fromJson(pageData as Map<String, dynamic>);
              await dbHandler.saveSurveyPage(page);

              if (page.questions != null) {
                for (final questionData in page.questions!) {
                  if (questionData is Map<String, dynamic>) {
                    final SurveyQuestion question = SurveyQuestion.fromJson(
                        questionData as Map<String, dynamic>);
                    await dbHandler.saveSurveyQuestion(question);
                  }
                }
              }
            }
          }

          // Ajoutez les données de surveyData à la tableData
          /*setState(() {
            tableData!.add(survey);
          });*/
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
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.goBack))
            ],
          ),
        );
      } else {
        LoadingIndicatorDialog().dismiss();

        print(usercountry);
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

  // Fonction pour recuperer les surveys sauvegardé en local
  Future<void> fetchSurveysFromLocal() async {
    try {
      final surveys = await dbHandler.getSurveys();

      // Effacez les données précédentes de la tableData
      setState(() {
        tableData = [];
      });

      // Ajoutez les données locales à la tableData
      setState(() {
        tableData!.addAll(surveys);
      });
    } catch (e) {
      // Gérez les erreurs
      print('Erreur lors du chargement des enquêtes locales : $e');
    }
  }

  // Appel de api pour transferer tout les eum au serveur
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
          Uri.parse(
              '$BASEURL/u/admin/offline/eum/$selectedSurveyId/$userId/save'),
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
                ),
              ),
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
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          bool isConnected = connectivity != ConnectivityResult.none;
          if (isConnected) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      horizontalMargin: 20,
                      dividerThickness: 4,
                      dataRowHeight: 80,
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
                            label: Text(AppLocalizations.of(context)!.status)),
                        DataColumn(
                          label: const Text('Offline'),
                          // Ajoutez une condition pour désactiver la colonne si la connexion est inactive
                          onSort: isConnected ? null : null,
                        ),
                        DataColumn(
                          label: const Text('Download'),
                          // Ajoutez une condition pour désactiver la colonne si la connexion est inactive
                          onSort: isConnected ? null : null,
                        ),
                      ],
                      // Remplacez le DataRow dans votre DataTable par ce code
                      rows: (tableData ?? [])
                          .map(
                            (data) => DataRow(
                              cells: [
                                DataCell(
                                  InkWell(
                                    // Ajoutez onTap pour ouvrir la page souhaitée
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EUMDetailsPageCopy(
                                            surveyCreation: data,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(data.title),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                    },
                                    child: Center(
                                      child: Text(data.category),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                    },
                                    child: Center(
                                      child: Text(data.status),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                    },
                                    // Utilisez une condition pour afficher une icône verte si la connexion est active, sinon rouge
                                    child: isConnected
                                        ? const Center(
                                            child: Icon(
                                              Icons.error_outline_rounded,
                                              color: Colors.red,
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              color: Colors.green,
                                            ),
                                          ),
                                  ),
                                ),
                                DataCell(
                                  isConnected
                                      ? IconButton(
                                          onPressed: () {
                                            // Attribuez l'ID du sondage sélectionné
                                            setState(() {
                                              selectedSurveyId = data.id;
                                            });
                                            fetchDataAndSaveOneSurveyToDatabase();
                                          },
                                          icon: const Icon(
                                            Icons.downloading_rounded,
                                            color: Colors.green,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.downloading_rounded,
                                          color: Colors.red,
                                        ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                // Utilisez isConnected pour conditionner l'affichage des boutons
                ElevatedButton(
                  onPressed: isConnected ? sendAllSurvey : null,
                  child: Text(AppLocalizations.of(context)!.transferer),
                ),
                ElevatedButton(
                  onPressed: isConnected
                      ? fetchDataAndSaveToDatabase
                      : fetchSurveysFromLocal,
                  child: Text(AppLocalizations.of(context)!.download),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      horizontalMargin: 20,
                      dividerThickness: 4,
                      dataRowHeight: 80,
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
                            label: Text(AppLocalizations.of(context)!.status)),
                        DataColumn(
                          label: const Text('Offline'),
                          // Ajoutez une condition pour désactiver la colonne si la connexion est inactive
                          onSort: isConnected ? null : null,
                        ),
                        DataColumn(
                          label: const Text('Download'),
                          // Ajoutez une condition pour désactiver la colonne si la connexion est inactive
                          onSort: isConnected ? null : null,
                        ),
                      ],
                      // Remplacez le DataRow dans votre DataTable par ce code
                      rows: (tableData ?? [])
                          .map(
                            (data) => DataRow(
                              cells: [
                                DataCell(
                                  InkWell(
                                    // Ajoutez onTap pour ouvrir la page souhaitée
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EUMDetailsPageCopy(
                                            surveyCreation: data,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(data.title),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                    },
                                    child: Center(
                                      child: Text(data.category),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                    },
                                    child: Center(
                                      child: Text(data.status),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                    },
                                    // Utilisez une condition pour afficher une icône verte si la connexion est active, sinon rouge
                                    child: isConnected
                                        ? const Center(
                                            child: Icon(
                                              Icons.error_outline_rounded,
                                              color: Colors.red,
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              color: Colors.green,
                                            ),
                                          ),
                                  ),
                                ),
                                DataCell(
                                  isConnected
                                      ? IconButton(
                                          onPressed: () {
                                            // Attribuez l'ID du sondage sélectionné
                                            setState(() {
                                              selectedSurveyId = data.id;
                                            });
                                            fetchDataAndSaveOneSurveyToDatabase();
                                          },
                                          icon: const Icon(
                                            Icons.downloading_rounded,
                                            color: Colors.green,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.downloading_rounded,
                                          color: Colors.red,
                                        ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                // Utilisez isConnected pour conditionner l'affichage des boutons
                ElevatedButton(
                  onPressed: isConnected ? null : sendAllSurvey,
                  child: Text(AppLocalizations.of(context)!.transferer),
                ),
                ElevatedButton(
                  onPressed: isConnected ? fetchSurveysFromLocal : null,
                  child: Text(AppLocalizations.of(context)!.download),
                ),
              ],
            );
          }
        },
        child: CircularProgressIndicator(), // Mettez votre widget original ici
      ),
    );
  }
}
