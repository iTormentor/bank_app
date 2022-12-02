import 'package:bank_app/services/dummy_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {

  static final Database _instance = Database._();
  String uid = "0";
  static int nextAccount = 18225512350;

  static Database getInstance(){
    return _instance;
  }

  Database._();

  Future<void> createAccount(Map<String, dynamic> data) async{
    final path = "/users/$uid/account/$nextAccount;";
    nextAccount++;
    final documentReference = FirebaseFirestore.instance.doc(path);
    print(FirebaseFirestore.instance);
    await documentReference.set(data);
  }


}
