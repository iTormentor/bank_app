import 'package:flutter/material.dart';

import '../services/dummy_data.dart';

class AccountHistory extends StatelessWidget {
  final Wallet wallet;


  const AccountHistory({super.key, required Wallet this.wallet});

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
        ],
      ),
    );
  }
}
