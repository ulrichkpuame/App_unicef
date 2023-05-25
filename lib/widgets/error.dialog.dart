

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:unicefapp/_api/dioException.dart';
import 'package:unicefapp/widgets/navigator_key.dart';

class ErrorDialog {
  static final ErrorDialog _singleton = ErrorDialog._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory ErrorDialog() {
    return _singleton;
  }

  ErrorDialog._internal();

  show(DioError e) {
    if(isDisplayed) {
      return;
    }
    showDialog<void>(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          _context = context;
          isDisplayed = true;
          return AlertDialog(
            title: const Text('Erreur'),
            content: Text(DioExceptions.fromDioError(e).toString()),
            actions: [
              Center(child: TextButton(
                onPressed: () {dismiss();},
                child: const Text('OK', style: TextStyle(fontSize: 20),),
              ),)
            ],
          );
        }
    );
  }

  dismiss() {
    if(isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}