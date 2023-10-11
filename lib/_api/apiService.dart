import 'package:unicefapp/_api/dioClient.dart';
import 'package:unicefapp/_api/endpoints.dart';
import 'package:unicefapp/models/dto/users.dart';

class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

  Future<List<User>> getUsers() async {
    final response = await _dioClient.get(Endpoints.user);
    List<User> users =
        (response.data as List).map((e) => User.fromJson(e)).toList();
    return users;
  }
}
