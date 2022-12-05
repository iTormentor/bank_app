import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

// Used to communicate with the Firestore database
// Also stores some local variables for easier access
class Database {
  static final Database _instance = Database._();
  String uid = "0";
  List<Wallet> cachedWallets = [];

  static Database getInstance() {
    return _instance;
  }

  Database._();

  // Used to generate random number for wallets/accounts
  int newAccountNumber() {
    int nextAccount =
        11111111111 + Random().nextInt(888888888) * 100 + Random().nextInt(88);
    return nextAccount;
  }

  // Used to create a new wallet/account for the logged in user in Firestore database
  Future<void> createWallet(String accountName, bool spendingAccount) async {
    int accountNumber = newAccountNumber();
    Wallet wallet = Wallet(accountName, accountNumber,
        spendingAccount: spendingAccount, cardActive: spendingAccount);
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
    await documentReference2.set({"owner": uid});
  }

  // Returns all the wallets owned by the user in Firestore database
  Stream<List<Wallet>> getWallets() {
    var path = "users/$uid/accounts";
    final ref = FirebaseFirestore.instance.collection(path);
    final snapshots = ref.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map((snapshot) {
          final data = snapshot.data();
          Wallet wallet = Wallet(data["accountName"], data["accountId"],
              balance: double.parse(data["balance"].toString()),
              spendingAccount: data["spendingAccount"],
              cardActive: data["cardActive"]);
          addWallet(wallet);
          return wallet;
        }).toList());
  }

  // Adds wallet to locally stored wallets
  void addWallet(Wallet newWallet) {
    for (Wallet wallet in cachedWallets) {
      if (wallet.walletId == newWallet.walletId) {
        return;
      }
    }
    cachedWallets.add(newWallet);
  }

  // Updates balance of locally stored wallets
  void updateCachedWallet(Wallet wallet, double amount) {
    for (int i = 0; i < cachedWallets.length; i++) {
      if (cachedWallets[i].walletId == wallet.walletId) {
        cachedWallets[i].balance = wallet.balance + amount;
      }
    }
  }

  // Used to retrieve the names of wallets stored locally
  // Used in correlation with account history to display sender/receiver
  String findCachedWallet(int walletId) {
    String name = "Unknown";
    for (int i = 0; i < cachedWallets.length; i++) {
      if (cachedWallets[i].walletId == walletId) {
        name = cachedWallets[i].accountName;
      }
    }
    return name;
  }

  // Used to handle all the logic used when transferring money
  // between the users own accounts
  // Creates transactions and updates account balance in the
  // Firestore database
  Future<void> createTransferTransaction(
      Wallet fromWallet, Wallet toWallet, double balance) async {
    addTransaction(uid, fromWallet.walletId, toWallet.walletId, -balance);
    updateSelfBalance(fromWallet, -balance);
    updateCachedWallet(fromWallet, -balance);

    addTransaction(uid, toWallet.walletId, fromWallet.walletId, balance);
    updateSelfBalance(toWallet, balance);
    updateCachedWallet(toWallet, balance);
  }

  // Updates the balance of a wallet owned by the user
  Future<void> updateSelfBalance(Wallet wallet, double amount) async {
    var path = "users/$uid/accounts/${wallet.walletId}";
    final documentReference = FirebaseFirestore.instance.doc(path);
    documentReference.update({"balance": wallet.balance + amount});
    updateCachedWallet(wallet, wallet.balance + amount);
  }

  // Doesn't work!
  // Updates the balance of the receiving wallet in Firestore database
  Future<void> updateReceiverBalance(int walletId, double change) async {
    String owner = await getWalletOwner(walletId);

    var path = "users/$owner/accounts/$walletId";
    final documentReference = FirebaseFirestore.instance.doc(path);
    double oldBalance = 0;
    await getBalance(owner, walletId).then((value) => {oldBalance = value});
    double newValue = oldBalance + change;
    await documentReference.update({"balance": newValue});
  }

  // Returns just the balance of a given wallet with a given userId
  Future<double> getBalance(String userId, int walletId) async {
    var path = "users/$userId/accounts/$walletId";
    final ref = FirebaseFirestore.instance.doc(path).get();
    ref.then((DocumentSnapshot snapshot) {
      if (snapshot.data() != null) {
        return snapshot["balance"].toString();
      }
    });
    return 0;
  }

  // Creates a transaction document in the Firestore database
  Future<void> addTransaction(
      String userId, int walletId, int destinationId, double amount) async {
    String date = DateTime.now().toString();

    var path = "users/$userId/accounts/$walletId/transactions/$date";
    final documentReference1 = FirebaseFirestore.instance.doc(path);

    documentReference1.set({
      "amount": amount,
      "destinationWalletId": destinationId,
      "dateTime": date,
    });
  }

  // Returns all the transactions for a wallet owned
  // by the logged in user
  // Data is gathered from the Firestore database
  Stream<List<Transaction>> getTransactions(int walletId) {
    var path = "users/$uid/accounts/$walletId/transactions";
    final ref = FirebaseFirestore.instance
        .collection(path)
        .orderBy("dateTime", descending: true);
    final snapshots = ref.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map((snapshot) {
          final data = snapshot.data();
          return Transaction(double.parse(data["amount"].toString()),
              data["destinationWalletId"],
              dateTime: data["dateTime"]);
        }).toList());
  }

  // Checks the Firestore database to find the userID of the wallet
  // Returns "Unknown" if the user is outside our database
  Future<String> getWalletOwner(int walletId) async {
    var path = "userWallet/$walletId";
    final ref = FirebaseFirestore.instance.doc(path).get();
    String receiver = "Unknown";
    await ref.then((DocumentSnapshot snapshot) {
      if (snapshot.data() != null) {
        receiver = snapshot["owner"];
        return snapshot["owner"];
      }
    });
    await Future.delayed(const Duration(seconds: 2));
    return receiver;
  }
}

// Used to declare the typing of an instance of a wallet
class Wallet {
  final bool spendingAccount;
  bool cardActive = false;
  final int walletId;
  double balance;
  String accountName;

  Wallet(this.accountName, this.walletId,
      {this.balance = 1000.0,
      this.spendingAccount = false,
      this.cardActive = false});
}

// Used to declare the typing of an instance of a wallet
class Transaction {
  String dateTime = DateTime.now().toString();
  double amount;
  int destinationWalletID;

  Transaction(this.amount, this.destinationWalletID, {dateTime}) {
    if (dateTime != null) {
      this.dateTime = dateTime;
    }
  }
}
