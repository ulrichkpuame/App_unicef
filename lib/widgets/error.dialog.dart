import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:unicefapp/_api/dioException.dart';
import 'package:unicefapp/widgets/navigator_key.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorDialog {
  static final ErrorDialog _singleton = ErrorDialog._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory ErrorDialog() {
    return _singleton;
  }

  ErrorDialog._internal();

  // ignore: deprecated_member_use
  show(DioError e) {
    if (isDisplayed) {
      return;
    }
    showDialog<void>(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          _context = context;
          isDisplayed = true;
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.error),
            content: Text(DioExceptions.fromDioError(e).toString()),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    dismiss();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.ok,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          );
        });
  }

  dismiss() {
    if (isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}
