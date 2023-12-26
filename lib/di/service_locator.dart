import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:unicefapp/_api/apiService.dart';
import 'package:unicefapp/_api/authService.dart';
import 'package:unicefapp/_api/dioClient.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/db/database.connection.dart';
import 'package:unicefapp/db/local.servie.dart';
import 'package:unicefapp/db/repository.dart';

final locator = GetIt.instance;

Future<void> setup() async {
  locator.registerSingleton(const FlutterSecureStorage());
  locator
      .registerSingleton(TokenStorageService(locator<FlutterSecureStorage>()));
  locator.registerSingleton(Dio());
  locator.registerSingleton(AuthService(locator<TokenStorageService>()));
  locator.registerSingleton(DioClient(locator<Dio>()));
  locator.registerSingleton(ApiService(locator<DioClient>()));
  locator.registerSingleton(DatabaseConnection());
  locator.registerSingleton(Repository(locator<DatabaseConnection>()));
  locator.registerSingleton(LocalService(locator<Repository>()));
}
