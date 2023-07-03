import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:unicefapp/ui/pages/trace.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';

class SnapTracePage extends StatefulWidget {
  @override
  _SnapTracePageState createState() => _SnapTracePageState();
}

class _SnapTracePageState extends State<SnapTracePage> {
  //QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    //controller?.dispose();
    super.dispose();
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
                      MaterialPageRoute(builder: (context) => TracePage()),
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
                'Snap',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Snap batch number',
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
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRBarScannerCamera(
              key: qrKey,
              onError: (context, error) => Text(
                error.toString(),
                style: TextStyle(color: Colors.red),
              ),
              qrCodeCallback: (code) {
                Navigator.pop(context, code);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Placez le produit dans la zone de numérisation',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
