import 'dart:async';

class DummyData {

  static final DummyData _instance = DummyData._();
  final List<User> allUsers = [];
  final List<Wallet> allWallets = [];
  final List<Transaction> allTransactions = [];

  static DummyData getInstance() {
    return _instance;
  }

  DummyData._();

  void initializeDummyData() {
    final unknownUser = User("Unkown", "Unkown");
    final unknownWallet = Wallet(unknownUser, "Unknown receiver");
    final storeWallet1 = Wallet(unknownUser, "Coop Prix SA");
    final storeWallet2 = Wallet(unknownUser, "SPAR Norge AS");
    final user1 = User("Per", "per@per.no");
    final user2 = User("Ole", "ole@ole.no");

    allUsers.add(unknownUser);
    allUsers.add(user1);
    allUsers.add(user2);
    allWallets.add(unknownWallet);
    allWallets.add(storeWallet1);
    allWallets.add(storeWallet2);



    Wallet wallet1 = user1.createNewWallet("Savings account", balance: 100000.0);
    Wallet wallet2 = user1.createNewWallet("Spendings account", balance: 2000.0);

    Transaction(wallet1, 100, 2);
    Transaction(wallet1, 59.0, 5, dateTime: DateTime.utc(2022, 11, 20));
    Transaction(wallet1, 50, 2, dateTime:  DateTime.utc(2022, 10, 5));

    Transaction(wallet2, 100000, 0);


  }

  Wallet fetchWallet(int id){
      for (Wallet wallet in allWallets) {
        if (wallet.walletId == id) {
          return wallet;
        }
      }
      return allWallets[0];

  }

  Stream<List<Wallet>> getAllWalletsForUser(int id) {
    final controller = StreamController<List<Wallet>>();
    User? foundUser;
    for (User user in allUsers) {
      if (user.userId == id) {
        foundUser = user;
      }
    }
    if (foundUser != null) {
        controller.add(foundUser.wallets);
      }
      controller.close();
      return controller.stream;
    }
  }



class User {

  static int _totalUsers = 0;

  final int userId;
  final String name;
  final String email;
  List<Wallet> wallets = [];

  User(this.name, this.email) : userId = _totalUsers++;

  Wallet createNewWallet(String walletName, {balance}){
    Wallet newWallet = Wallet(this, walletName, balance: balance);
    wallets.add(newWallet);
    DummyData.getInstance().allWallets.add(newWallet);
    return newWallet;
  }

  }

class Wallet {
  static int _walletNumber = 18225512345;

  final User owner;
  final int walletId;
  final List<Transaction> transactions = [];
  double balance;
  String accountName;

  Wallet(this.owner, this.accountName, {this.balance = 1000.0}) : walletId = _walletNumber++;

  Stream<List<Transaction>> fetchTransactions(){
    final controller = StreamController<List<Transaction>>();
    controller.add(transactions);
    controller.close();
    return controller.stream;
  }

}

class Transaction {
  Wallet wallet;
  DateTime dateTime = DateTime.now();
  double amount;
  int destinationWalletID;

  Transaction(this.wallet, this.amount, this.destinationWalletID, {dateTime}){
    if (dateTime != null){
      this.dateTime = dateTime;
    }
    wallet.transactions.add(this);
  }
}


// TODO Create methods one card for user
// TODO Create method to transfer money between users own cards
// TODO Create method to pay from own account to outside account