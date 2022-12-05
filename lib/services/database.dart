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
                  balance: double.parse(data["balance"].toString()),
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

  void updateCachedWallet(Wallet wallet, double amount) {
    for (int i = 0; i < cachedWallets.length; i++) {
      if (cachedWallets[i].walletId == wallet.walletId) {
        cachedWallets[i].balance += amount;
      }
    }
  }

  String findCachedWallet(int walletId) {
    String name = "Unknown";
    for (int i = 0; i < cachedWallets.length; i++) {
      if (cachedWallets[i].walletId == walletId) {
        name = cachedWallets[i].accountName;
      }
    }
    return name;
  }

    Future<void> createFullTransaction(Wallet wallet, int destinationId,
        double balance) async {
      addTransaction(uid, wallet.walletId, destinationId, -balance);
      updateSelfBalance(wallet, -balance);
      String receiver = await getWalletOwnerFuture(destinationId);
      print(receiver);
      if (receiver != "Unknown") {
        addTransaction(
            receiver.toString(), destinationId, wallet.walletId, balance);
        updateReceiverBalance(destinationId, balance);
      }
    }

    Future<void> updateSelfBalance(Wallet wallet, double amount) async {
      var path = "users/$uid/accounts/${wallet.walletId}";
      final documentReference = FirebaseFirestore.instance.doc(path);
      documentReference.update({"balance": wallet.balance + amount});
      updateCachedWallet(wallet, wallet.balance + amount);
    }


    Future<void> updateReceiverBalance(int walletId, double change) async {
      String owner = await getWalletOwnerFuture(walletId);

      var path = "users/$owner/accounts/$walletId";
      final documentReference = FirebaseFirestore.instance.doc(path);
      double oldBalance = 0;
      await getBalance(owner, walletId).then((value) => {oldBalance = value});
      double newValue = oldBalance + change;
      await documentReference.update({"balance": newValue});
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
        double amount) async {
      String date = DateTime.now().toString();

      var path = "users/$userId/accounts/$walletId/transactions/$date";
      final documentReference1 = FirebaseFirestore.instance.doc(path);

      documentReference1.set({
        "amount": amount,
        "destinationWalletId": destinationId,
        "dateTime": date,
      });
    }

    Stream<List<Transaction>> getTransactions(int walletId) {
      var path = "users/$uid/accounts/$walletId/transactions";
      final ref = FirebaseFirestore.instance.collection(path).orderBy(
          "dateTime", descending: true);
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

    String getWalletOwner(int walletId) {
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


    Future<String> getWalletOwnerFuture(int walletId) async {
      var path = "userWallet/$walletId";
      final ref = FirebaseFirestore.instance.doc(path).get();
      String receiver = "Unknown";
      await ref.then((DocumentSnapshot snapshot) {
        if (snapshot.data() != null) {
          receiver = snapshot["owner"];
          return snapshot["owner"];
        } else {
          print(snapshot["owner"]);
        }
      });
      await Future.delayed(Duration(seconds: 2));
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

