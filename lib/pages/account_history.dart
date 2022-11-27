import 'package:flutter/material.dart';

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
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              //foregroundColor: Colors.white,
              //backgroundColor: Colors.green,
              shadowColor: Colors.greenAccent,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              minimumSize: const Size(100, 200), //////// HERE
            ),
            onPressed: () {},
            child: Text("Spending Balance: ${wallet.balance} kr"),
          ),
          SizedBox(height: 16,),
          const Text("Transactions",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,

          ),),
          _buildTransactionItems()
        ],
      ),
    );
  }

  Widget _buildTransactionItems() {
    return StreamBuilder<List<Transaction>>(stream: wallet.fetchTransactions(),
    builder: (context, snapshot){
      if(snapshot.hasData){
        return Column(
          children:
            snapshot.data!.map<Widget>((transaction) => _transactionItem(transaction)).toList(),
        );
      } else {
        return Card();
      }
    });
  }

  Widget _transactionItem(Transaction transaction){
    Wallet wallet = DummyData.getInstance().fetchWallet(transaction.destinationWalletID);
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(children: [
            Text(wallet.accountName),
            Text("${transaction.amount}"),
          ],),
        )
    );
  }
}
