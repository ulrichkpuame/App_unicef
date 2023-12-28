// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicefapp/ui/pages/login.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';

class CountryPage extends StatefulWidget {
  const CountryPage({Key? key}) : super(key: key);

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  String selectedCountryCode = ''; // Initialiser à une valeur dans la liste
  final TextEditingController countryController = TextEditingController();

  bool ligth = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCountry();
  }

  _loadSavedCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedCountryCode = prefs.getString('selectedCountryCode') ?? '';
  }

  _saveSelectedCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedCountryCode', selectedCountryCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Defaults.appBarColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(80),
              ),
            ),
            child: const Column(
              children: [
                SizedBox(height: 60),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    'Welcome to',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Defaults.white),
                  ),
                  subtitle: Text('Trackit EUM App',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white)),
                  trailing: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/unicef1.png'),
                  ),
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Defaults.appBarColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  const Text(
                    "Select Your Country",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CountryListPick(
                          appBar: AppBar(
                            backgroundColor: Colors.blue,
                            title: const Text('Select country'),
                          ),
                          // To disable option set to false
                          theme: CountryTheme(
                            isShowFlag: true,
                            isShowTitle: true,
                            isShowCode: false,
                            isDownIcon: true,
                            showEnglishName: true,
                          ),
                          // Set default value
                          initialSelection: 'US',
                          // or
                          // initialSelection: 'US'
                          onChanged: (CountryCode? code) {
                            setState(() {
                              selectedCountryCode = code!.code!;
                              _saveSelectedCountry();
                            });
                          },
                          // Whether to allow the widget to set a custom UI overlay
                          useUiOverlay: true,
                          // Whether the country list should be wrapped in a SafeArea
                          useSafeArea: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: selectedCountryCode.isNotEmpty
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginPage()));
                            }
                          : null, // Désactive le bouton si aucun pays n'est choisi
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
