import 'package:bank_app/services/dummy_data.dart';

class Database {


  static final Database _instance = Database._();

  User? loggedInUser;

  static Database getInstance() {
    return _instance;
  }

  Database._();




  User? getLoggedInUser(){
    return loggedInUser = DummyData.getInstance().getLoggedInUser();
  }


  Wallet? getWalletsForUser(){
    DummyData.getInstance().getAllWalletsForUser(loggedInUser?.userId ?? 0);
  }

}