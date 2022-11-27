import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/dummy_data.dart';

class AccountHistory extends StatelessWidget {
  final Wallet wallet;

  const AccountHistory({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Account History'),
        elevation: 10.0,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAccountCard(),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Transactions",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          _buildTransactionItems()
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Card(
      color: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: SizedBox(
        height: 100,
        width: 300,
        child: Center(
          child: Text(
            "Spending Balance: ${wallet.balance} kr",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItems() {
    return StreamBuilder<List<Transaction>>(
        stream: wallet.fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: snapshot.data!
                  .map<Widget>((transaction) => _transactionItem(transaction))
                  .toList(),
            );
          } else {
            return Text("Halla");
          }
        });
  }

  Widget _transactionItem(Transaction transaction) {
    Wallet wallet =
        DummyData.getInstance().fetchWallet(transaction.destinationWalletID);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return Card(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                  "${dateFormat.format(transaction.dateTime)} ${getWeekday(transaction.dateTime.weekday)}"),
              Row(
                children: [
                  Text(wallet.accountName),
                  const Spacer(),
                  Text("${transaction.amount}"),
                ],
              ),
            ],
          ),
        ));
  }

  String getWeekday(int day) {
    switch (day) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "Wrong input";
    }
  }
}
