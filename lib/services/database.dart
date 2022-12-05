import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Database {

  static final Database _instance = Database._();
  String uid = "0";
  List<Wallet> cachedWallets = [];

  static Database getInstance() {
    return _instance;
  }

  Database._();

  int newAccountNumber() {
    int nextAccount = 11111111111 + Random().nextInt(888888888) * 100 +
        Random().nextInt(88);
    return nextAccount;
  }

  Future<void> createWallet(String accountName, bool spendingAccount) async {
    int accountNumber = newAccountNumber();
    Wallet wallet = Wallet(
        accountName, accountNumber, spendingAccount: spendingAccount,
        cardActive: spendingAccount);
    Map<String, dynamic> userData = {
      "accountName": wallet.accountName,
      "balance": wallet.balance,
      "spendingAccount": wallet.spendingAccount,
      "cardActive": wallet.cardActive,
      "accountId": accountNumber,
    };
    var userPath = "users/$uid/accounts/$accountNumber";
    var userLink = "userWallet/$accountNumber";
    final documentReference1 = FirebaseFirestore.instance.doc(userPath);
    await documentReference1.set(userData);
    final documentReference2 = FirebaseFirestore.instance.doc(userLink);
    await documentReference2.set(
        {"owner": uid}
    );
  }


  Stream<List<Wallet>> getWallets() {
    var path = "users/$uid/accounts";
    final ref = FirebaseFirestore.instance.collection(path);
    final snapshots = ref.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map(
                (snapshot) {
              final data = snapshot.data();
              Wallet wallet = Wallet(
                  data["accountName"],
                  data["accountId"],
                  balance: data["balance"],
                  spendingAccount: data["spendingAccount"],
                  cardActive: data["cardActive"]
              );
              addWallet(wallet);
              return wallet;
            }
        ).toList());
  }

  void addWallet(Wallet newWallet) {
    for (Wallet wallet in cachedWallets) {
      if (wallet.walletId == newWallet.walletId) {
        return;
      }
    }
    cachedWallets.add(newWallet);
  }


  Future<void> createFullTransaction(Wallet wallet, int destinationId,
      double balance) async {
    addTransaction(uid, wallet.walletId, destinationId, -balance);
    updateSelfBalance(wallet.walletId, -balance);
    String receiver = getWalletOwner(destinationId);
    if (receiver != "Unknown") {
      addTransaction(receiver, destinationId, wallet.walletId, balance);
      updateReceiverBalance(destinationId, balance);
    }
  }

    Future<void> updateSelfBalance(int walletId, double amount) async {
      var path = "users/$uid/accounts/$walletId";
      final documentReference = FirebaseFirestore.instance.doc(path);

      await documentReference.update({"balance" : 2});
    }


    Future<void> updateReceiverBalance(int walletId, double change) async {
    String owner = getWalletOwner(walletId);

    var path = "users/$owner/accounts/$walletId";
    final documentReference = FirebaseFirestore.instance.doc(path);
    double oldBalance = 0;
    await getBalance(owner, walletId).then((value) => {oldBalance = value});
    double newValue = oldBalance + change;
    await documentReference.update({"balance" : newValue});
  }


  Future<double> getBalance(String owner, int walletId) async {
    var path = "users/$owner/accounts/$walletId";
    final ref = FirebaseFirestore.instance.doc(path).get();
    ref.then((DocumentSnapshot snapshot) {
      if (snapshot.data() != null) {
        return snapshot["balance"].toString();
      }
    });
    return 0;
  }

  Future<void> addTransaction(String userId, int walletId, int destinationId,
      double balance) async {
    var path = "users/$userId/accounts/$walletId/transactions";
    String date = DateTime.now().toString();
    CollectionReference transactions = FirebaseFirestore.instance.collection(
        path);
    //final documentReference1 = FirebaseFirestore.instance.doc(path1);
    await transactions.add({
      "amount": balance,
      "destinationWalletId": destinationId,
      "dateTime": date,
    });
  }

  Stream<List<Transaction>> getTransactions(int walletId) {
    var path = "users/$uid/accounts/$walletId/transactions";
    final ref = FirebaseFirestore.instance.collection(path);
    final snapshots = ref.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map(
                (snapshot) {
              final data = snapshot.data();
              return Transaction(
                  data["amount"],
                  data["destinationWalletId"],
                  dateTime: data["dateTime"]
              );
            }
        ).toList());
  }

    String getWalletOwner(int walletId)  {
    var path = "userWallet/$walletId";
    final ref = FirebaseFirestore.instance.doc(path).get();
    String receiver = "Unknown";
    ref.then((DocumentSnapshot snapshot) {
      if (snapshot.data() != null) {
        return snapshot["owner"].toString();
      }
    });
    return receiver;
  }

}



class Wallet {
  final bool spendingAccount;
  bool cardActive = false;
  final int walletId;
  double balance;
  String accountName;

  Wallet(this.accountName, this.walletId,
      {this.balance = 1000.0, this.spendingAccount = false,this.cardActive = false});
}

class Transaction {
  String dateTime = DateTime.now().toString();
  double amount;
  int destinationWalletID;

  Transaction(this.amount, this.destinationWalletID, {dateTime});

}

