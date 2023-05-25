import 'package:unicefapp/_api/dioClient.dart';
import 'package:unicefapp/models/dto/agent.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  // Future<Agent> getUserConnected(String username) async {
  //   String agentEndpoint = '/agents/$username/slim/byusername';
  //   final response = await _dioClient.get(agentEndpoint);
  //   return Agent.fromJson(response.data);
  // }
}
