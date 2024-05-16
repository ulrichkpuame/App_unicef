// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/apiService.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/db/local.servie.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/history.transfer.dart';
import 'package:unicefapp/models/dto/issues.dart';
import 'package:unicefapp/models/dto/material.details.dart';
import 'package:unicefapp/ui/pages/Acknowledge/acknowledge.details.page%20copy.dart';
import 'package:unicefapp/ui/pages/EUM/eum.details.page.copy.dart';
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/ui/pages/Acknowledge/acknowledge.details.page.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unicefapp/widgets/error.dialog.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';

import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity/connectivity.dart' as connectivity;

class AcknowledgePageCopy extends StatefulWidget {
  const AcknowledgePageCopy({super.key});

  @override
  _AcknowledgePageCopyState createState() => _AcknowledgePageCopyState();
}

class _AcknowledgePageCopyState extends State<AcknowledgePageCopy> {
  final storage = locator<TokenStorageService>();
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  late final Future<Agent?> _futureAgentConnected;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<HistoryTransfer>? tableData;
  String BASEURL = 'https://www.trackiteum.org';
  String? usercountry = '';
  String? selectTransferId;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    // transferType = tableData!.elementAt(0).typeOfTransfer;
    _futureAgentConnected.then((value) {
      if (value != null) {
        setState(() {
          usercountry = value.country;
        });
        // Check for internet connectivity
        checkInternetConnectivity().then((isConnected) {
          if (isConnected) {
            // If connected, fetch data from the server
            fetchAcknowAndFillTable(usercountry!);
          } else {
            // If not connected, fetch data from local storage
            fetchAcknowFromLocal();
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

  //----------- CHARGE LES INFORMATIONS DE ACKNOWLEDGE --------------//
  Future<void> fetchAcknowAndFillTable(String country) async {
    String apiUrl = '$BASEURL/u/admin/transfer/$country';

    try {
      final response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        print('SUCCESS');

        final List<dynamic> data = response.data;
        List<HistoryTransfer> historyTrans =
            data.map((json) => HistoryTransfer.fromJson(json)).toList();
        print(response);
        // Effacez les données précédentes de la tableData
        setState(() {
          tableData = [];
        });

        // Ajoutez les nouvelles données à la tableData
        setState(() {
          tableData!.addAll(historyTrans);
        });

        // Affichez un message de succès ou effectuez d'autres actions si nécessaire
        // ...
      } else {
        print('ERROR');
        throw Exception('Failed to load acknowledge');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //  Appel de api pour telecharger tout les acknowledges dispo
  Future<void> fetchDataAndSaveAcknowToDatabase() async {
    var url = Uri.parse('$BASEURL/u/admin/transfer/$usercountry');
    LoadingIndicatorDialog().show(context);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);

        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          try {
            // Change this line to decode the response body as a List<dynamic>
            final List<dynamic> dataList = jsonDecode(response.body);

            // Iterate through the list and process each item
            for (final Map<String, dynamic> data in dataList) {
              final HistoryTransfer historyTransfer =
                  HistoryTransfer.fromJson(data);

              // Save the historyTransfer object
              await dbHandler.saveHistoryTransfer(historyTransfer);

              // Save each MaterialDetails
              for (final materialData in historyTransfer.materialDetails) {
                final MaterialDetails materialDetails =
                    MaterialDetails.fromJson(materialData.toJson());

                // Splitting materialQuantity and joining the parts if there is a comma
                // For Quantity
                final List<String> quantityParts =
                    materialDetails.materialQuantity.split(',');
                String materialQuantity = quantityParts.join('');
                materialDetails.materialQuantity = materialQuantity;

                // For Material description
                final List<String> mateDescrip =
                    materialDetails.materialDescription.split(',');
                String materialDescription = mateDescrip.join('');
                materialDetails.materialDescription = materialDescription;

                await dbHandler.saveMaterialDetails(materialDetails);
              }
            }

            LoadingIndicatorDialog().dismiss();

            // The rest of your code for displaying success
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
                    child: Text(AppLocalizations.of(context)!.goBack),
                  ),
                ],
              ),
            );
          } catch (e) {
            // Handle JSON decoding error
            print('Error decoding JSON: $e');
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
                    height: 160,
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
                          'Erreur lors du chargement des données',
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
                );
              },
            );
          }
        } else {
          // Handle empty response body
          print('Empty response body');
          // The rest of your code for handling empty response
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
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle non-200 status code
        print('Non-200 status code: ${response.statusCode}');
        // The rest of your code for handling non-200 status code
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
                    const Text(
                      'Téléchargement pas disponible',
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
            );
          },
        );
      }
    } on DioError catch (e) {
      LoadingIndicatorDialog().dismiss();
      ErrorDialog().show(e);
    }
  }

  //  Appel de api pour telecharger un seul acknowledge
  Future<void> fetchDataAndSaveOneAcknowToDatabase() async {
    var url =
        Uri.parse('$BASEURL/u/admin/transfer/$usercountry/$selectTransferId');
    LoadingIndicatorDialog().show(context);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final HistoryTransfer historyTransfer = HistoryTransfer.fromJson(data);

        // Save the historyTransfer object
        await dbHandler.saveHistoryTransfer(historyTransfer);

        for (final materialData in historyTransfer.materialDetails) {
          final MaterialDetails materialDetails =
              MaterialDetails.fromJson(materialData.toJson());

          // Splitting materialQuantity and joining the parts if there is a comma
          // For Quantity
          final List<String> quantityParts =
              materialDetails.materialQuantity.split(',');
          String materialQuantity = quantityParts.join('');
          materialDetails.materialQuantity = materialQuantity;

          // For Material description
          final List<String> mateDescrip =
              materialDetails.materialDescription.split(',');
          String materialDescription = mateDescrip.join('');
          materialDetails.materialDescription = materialDescription;

          await dbHandler.saveMaterialDetails(materialDetails);
        }
        print('------- ID -------');
        print(historyTransfer.id);

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
                    'SUCCESS',
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
                      'ERROR',
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

  // Fonction pour recuperer les acknowledges sauvegardé en local
  Future<void> fetchAcknowFromLocal() async {
    try {
      final historyTransfer = await dbHandler.getHistorytransfer();

      // Effacez les données précédentes de la tableData
      setState(() {
        tableData = [];
      });

      // Ajoutez les données locales à la tableData
      setState(() {
        tableData!.addAll(historyTransfer);
      });
    } catch (e) {
      // Gérez les erreurs
      print('Erreur lors du chargement des enquêtes locales : $e');
    }
  }

  // Appel de api pour transferer tout les acknowledges au serveur
  void sendAllSurvey() async {
    List<Map<String, dynamic>> list = await dbHandler.readAllAcknow();

    try {
      if (list.isEmpty) {
        print('------------ ACKNOW EMPTY ---------');
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
        for (var item in tableData!) {
          String typeOfTransfer = item.typeOfTransfer;
          String idTransfer = item.id;

          var response = await http.post(
            Uri.parse(
                '$BASEURL/u/admin/acknowledge/$typeOfTransfer/$idTransfer/offline/$usercountry'),
            body: jsonEncode(list),
            headers: {
              "Content-type": "application/json",
            },
          );

          if (response.statusCode == 200) {
            print('------------ ACKNOW SUCESS ---------');
            print('Transfert Type: $typeOfTransfer');
            print('DATA: $list');
            // await dbHandler.deleteAllAcknow();
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
          } else {
            print('------------ ACKNOW ERROR ---------');
            print('Transfert Type: $typeOfTransfer');
            print('User ID: $idTransfer');
            print('DATA: $list');
            print('Error log: $e');
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
      drawer: const MyDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
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
                AppLocalizations.of(context)!.acknowledgeTitle,
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
              onPressed: () {
                // Actions à effectuer lorsque le bouton est pressé
              },
            ),
          ],
        ),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          // -----------  CORPS D'AFFICHAGE EN MODE ONLINE ----------------
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
                      dataRowHeight: 60,
                      showBottomBorder: true,
                      headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Defaults.bluePrincipal),
                      headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => Defaults.white),

                      columns: [
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.ip,
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.date,
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.type,
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.doc,
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.status,
                          style: const TextStyle(fontSize: 12),
                        )),
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
                                                AcknowledgeDetailsPageCopy(
                                                    historyTransfer: data)),
                                      );
                                    },
                                    child: Text(data.ip),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AcknowledgeDetailsPageCopy(
                                                    historyTransfer: data)),
                                      );
                                    },
                                    child: Center(
                                      child: Text(data.initiatingDate),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AcknowledgeDetailsPageCopy(
                                                    historyTransfer: data)),
                                      );
                                    },
                                    child: Center(
                                      child: Text(data.typeOfTransfer),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AcknowledgeDetailsPageCopy(
                                                    historyTransfer: data)),
                                      );
                                    },
                                    child: Center(
                                      child: Text(data.documentNumber),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AcknowledgeDetailsPageCopy(
                                                    historyTransfer: data)),
                                      );
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
                                              selectTransferId = data.id;
                                            });
                                            fetchDataAndSaveOneAcknowToDatabase();
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
                //------  BOUTTON TRANSFER  -------------
                ElevatedButton.icon(
                  onPressed: isConnected ? sendAllSurvey : null,
                  label: Text(AppLocalizations.of(context)!.transferer,
                      style: const TextStyle(color: Defaults.white)),
                  icon: const Icon(Icons.cloud_upload_sharp,
                      color: Defaults.white),
                ),

                //------  BOUTTON DOWNLOAD  -------------
                ElevatedButton.icon(
                  onPressed: isConnected
                      ? fetchDataAndSaveAcknowToDatabase
                      : fetchAcknowFromLocal,
                  label: Text(AppLocalizations.of(context)!.download,
                      style: const TextStyle(color: Defaults.white)),
                  icon: const Icon(Icons.cloud_download_outlined,
                      color: Defaults.white),
                ),
              ],
            );

            // -----------  CORPS D'AFFICHAGE EN MODE OFFLINE ----------------
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
                            label: Text(
                          AppLocalizations.of(context)!.ip,
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.date,
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.type,
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.doc,
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.status,
                          style: const TextStyle(fontSize: 12),
                        )),
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
                                                AcknowledgeDetailsPageCopy(
                                                    historyTransfer: data)),
                                      );
                                    },
                                    child: Text(data.ip),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AcknowledgeDetailsPageCopy(
                                                    historyTransfer: data)),
                                      );
                                    },
                                    child: Center(
                                      child: Text(data.initiatingDate),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AcknowledgeDetailsPageCopy(
                                                    historyTransfer: data)),
                                      );
                                    },
                                    child: Center(
                                      child: Text(data.typeOfTransfer),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AcknowledgeDetailsPageCopy(
                                                    historyTransfer: data)),
                                      );
                                    },
                                    child: Center(
                                      child: Text(data.documentNumber),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      // Ajoutez ici le code pour ouvrir la page souhaitée
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AcknowledgeDetailsPageCopy(
                                                    historyTransfer: data)),
                                      );
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
                                              selectTransferId = data.id;
                                            });
                                            fetchDataAndSaveOneAcknowToDatabase();
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
                ElevatedButton.icon(
                  onPressed: isConnected ? sendAllSurvey : null,
                  label: Text(AppLocalizations.of(context)!.transferer,
                      style: const TextStyle(color: Defaults.white)),
                  icon: const Icon(Icons.cloud_upload_sharp,
                      color: Defaults.white),
                ),
              ],
            );
          }
        },
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
