import 'package:bank_app/pages/account_history.dart';
import 'package:flutter/material.dart';

import '../services/dummy_data.dart';

class Overview extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [buildContent(context)],
      ),
    );
  }


  Widget buildContent(BuildContext context) {
    return StreamBuilder<List<Wallet>>(
        stream: DummyData.getInstance().getAllWalletsForUser(1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
                children:
                snapshot.data!.map<Widget>((wallet) =>
                    _walletItem(context, wallet)).toList(),
            );
          } else {
            return Text("You dont have any yet");
          }
        });
  }

  Widget _walletItem(BuildContext context, Wallet wallet) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => AccountHistory(wallet: wallet)));
        }, child: Text("${wallet.accountName}: ${wallet.balance} kr"));
  }

}



