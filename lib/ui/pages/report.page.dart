import 'package:flutter/material.dart';
import 'package:unicefapp/models/dto/history.transfer.dart';
import 'package:unicefapp/models/dto/organisation.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:unicefapp/models/dto/trace.dart';
import 'package:unicefapp/models/dto/users.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportDataPage extends StatefulWidget {
  @override
  _ReportDataPageState createState() => _ReportDataPageState();
}

class _ReportDataPageState extends State<ReportDataPage> {
  late List<Organisation> _chartData;
  late List<User> _chartDataUser;
  late List<Trace> _chartTraceData;
  late List<HistoryTransfer> _chartDataHistoryTransfer;
  late TooltipBehavior _tooltipBehavior;
  bool loading = true;
  String BASEURL = 'https://www.trackiteum.org';

  void getOrganisationData() async {
    var response = await http.get(
      Uri.parse('$BASEURL/reports/listOrgType'),
      headers: {
        "Content-type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List<Organisation> tempdata = organisationFromJson(response.body);
      setState(() {
        _chartData = tempdata;
        loading = false;
      });
    } else {
      // Gérer les erreurs de l'appel API
      print("Erreur lors de la récupération des données de l'API");
    }
  }

  void getUserData() async {
    var response = await http.get(
      Uri.parse('$BASEURL/reports/usertype'),
      headers: {
        "Content-type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List<User> tempdata = userFromJson(response.body);
      setState(() {
        _chartDataUser = tempdata;
        loading = false;
      });
    } else {
      // Gérer les erreurs de l'appel API
      print("Erreur lors de la récupération des données de l'API");
    }
  }

  void getHistoryTransferData() async {
    var response = await http.get(
      Uri.parse('$BASEURL/reports/historytransfer'),
      headers: {
        "Content-type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List<HistoryTransfer> tempdata = historyTransferFromJson(response.body);
      setState(() {
        _chartDataHistoryTransfer = tempdata;
        loading = false;
      });
    } else {
      // Gérer les erreurs de l'appel API
      print("Erreur lors de la récupération des données de l'API");
    }
  }

  void getTraceData() async {
    var response = await http.get(
      Uri.parse('$BASEURL/reports/trace'),
      headers: {
        "Content-type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List<Trace> tempdata = traceFromJson(response.body);
      setState(() {
        _chartTraceData = tempdata;
        loading = false;
      });
    } else {
      // Gérer les erreurs de l'appel API
      print("Erreur lors de la récupération des données de l'API");
    }
  }

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = []; // Initialisation avec une liste vide
    _chartDataUser = [];
    _chartDataHistoryTransfer = [];
    _chartTraceData = [];
    getOrganisationData();
    getHistoryTransferData();
    getUserData();
    getTraceData();
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
                AppLocalizations.of(context)!.reportTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.reportSubTitle,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //---------- ORGANIZATIONS ----------//
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
                            )
                          ],
                          color: Defaults.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 350,
                            width: 300,
                            child: SfCartesianChart(
                              title: ChartTitle(
                                  text: AppLocalizations.of(context)!
                                      .organizations,
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              legend: const Legend(isVisible: true),
                              tooltipBehavior: _tooltipBehavior,
                              series: <ChartSeries>[
                                StackedColumnSeries<Organisation, String>(
                                  dataSource: _chartData,
                                  xValueMapper: (Organisation org, _) => org.id,
                                  yValueMapper: (Organisation org, _) =>
                                      int.parse(org.name),
                                  name: AppLocalizations.of(context)!
                                      .organizationsDistri,
                                  pointColorMapper: (Organisation org, _) {
                                    if (int.parse(org.name) > 50) {
                                      return const Color.fromRGBO(
                                          100, 149, 237, 1);
                                    } else {
                                      return const Color.fromRGBO(
                                          75, 0, 130, 1);
                                    }
                                  },
                                )
                              ],
                              primaryXAxis: CategoryAxis(
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Mettre en gras les étiquettes de l'axe x
                                ),
                              ),
                              primaryYAxis: NumericAxis(
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Mettre en gras les étiquettes de l'axe y
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),

              //---------- USERS ----------//
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
                            )
                          ],
                          color: Defaults.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 400,
                            width: 300,
                            child: SfCartesianChart(
                              title: ChartTitle(
                                  text: AppLocalizations.of(context)!.users,
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              legend: const Legend(isVisible: true),
                              tooltipBehavior: _tooltipBehavior,
                              series: <ChartSeries>[
                                StackedColumnSeries<User, String>(
                                    dataSource: _chartDataUser,
                                    xValueMapper: (User user, _) => user.id,
                                    yValueMapper: (User user, _) =>
                                        int.parse(user.username.toString()),
                                    name:
                                        AppLocalizations.of(context)!.userData,
                                    pointColorMapper: (User user, _) {
                                      if (int.parse(user.username.toString()) >
                                          40) {
                                        return const Color.fromRGBO(
                                            0, 128, 128, 2);
                                      } else if (int.parse(
                                              user.username.toString()) <
                                          4) {
                                        return const Color.fromRGBO(
                                            210, 105, 30, 1);
                                      } else {
                                        return const Color.fromRGBO(
                                            189, 183, 107, 2);
                                      }
                                    })
                              ],
                              primaryXAxis: CategoryAxis(
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Mettre en gras les étiquettes de l'axe x
                                ),
                              ),
                              primaryYAxis: NumericAxis(
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Mettre en gras les étiquettes de l'axe y
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),

              //---------- HISTORY TRANSFER ----------//
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
                            )
                          ],
                          color: Defaults.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 400,
                            width: 300,
                            child: SfCartesianChart(
                              title: ChartTitle(
                                  text: AppLocalizations.of(context)!
                                      .historyTransfer,
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              legend: const Legend(isVisible: true),
                              tooltipBehavior: _tooltipBehavior,
                              series: <ChartSeries>[
                                StackedColumnSeries<HistoryTransfer, String>(
                                    dataSource: _chartDataHistoryTransfer,
                                    xValueMapper:
                                        (HistoryTransfer hisTrans, _) =>
                                            hisTrans.id,
                                    yValueMapper:
                                        (HistoryTransfer hisTrans, _) =>
                                            int.parse(hisTrans.documentNumber),
                                    name: AppLocalizations.of(context)!
                                        .transferData,
                                    pointColorMapper:
                                        (HistoryTransfer hisTrans, _) {
                                      if (int.parse(hisTrans.documentNumber) >
                                          40) {
                                        return Colors.green;
                                      } else if (int.parse(
                                              hisTrans.documentNumber) <
                                          4) {
                                        return Colors.orange;
                                      } else {
                                        return Colors.pinkAccent;
                                      }
                                    })
                              ],
                              primaryXAxis: CategoryAxis(
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Mettre en gras les étiquettes de l'axe x
                                ),
                              ),
                              primaryYAxis: NumericAxis(
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Mettre en gras les étiquettes de l'axe y
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),

              //---------- TRACE ----------//
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
                            )
                          ],
                          color: Defaults.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 400,
                            width: 300,
                            child: SfCartesianChart(
                              title: ChartTitle(
                                  text: AppLocalizations.of(context)!.trace,
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              legend: const Legend(isVisible: true),
                              tooltipBehavior: _tooltipBehavior,
                              series: <ChartSeries>[
                                StackedColumnSeries<Trace, String>(
                                    dataSource: _chartTraceData,
                                    xValueMapper: (Trace tra, _) => tra.id,
                                    yValueMapper: (Trace tra, _) =>
                                        int.parse(tra.material.toString()),
                                    name:
                                        AppLocalizations.of(context)!.traceData,
                                    pointColorMapper: (Trace tra, _) {
                                      if (int.parse(tra.material.toString()) >
                                          5) {
                                        return const Color.fromRGBO(
                                            0, 255, 255, 1);
                                      } else if (int.parse(
                                              tra.material.toString()) <
                                          4) {
                                        return const Color.fromRGBO(
                                            25, 25, 112, 1);
                                      } else {
                                        return Colors.pinkAccent;
                                      }
                                    })
                              ],
                              primaryXAxis: CategoryAxis(
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Mettre en gras les étiquettes de l'axe x
                                ),
                              ),
                              primaryYAxis: NumericAxis(
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Mettre en gras les étiquettes de l'axe y
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
