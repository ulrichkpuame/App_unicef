// import 'package:unicefapp/db/repository.dart';
// import 'package:unicefapp/models/dto/transfer.dart';

// class LocalService {
//   final Repository _repository;

//   LocalService(this._repository);

//   //DATA FROM TRANSFER
//   Future<List<Transfer>> readAllTransfer() async {
//     List<Transfer> transfers = [];
//     List<Map<String, dynamic>> list = await _repository.readData('transfer');
//     for (var transfer in list) {
//       transfers.add(Transfer.fromJson(transfer));
//     }
//     return transfers;
//   }

//   //SAVE TRANSFER IN DATABASE
//   SaveTransfer(Transfer transfer) async {
//     return await _repository.insertData('secteur', transfer.toJson());
//   }
// }
