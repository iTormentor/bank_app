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
              children: snapshot.data!
                  .map<Widget>((wallet) => _walletItem(context, wallet))
                  .toList(),
            );
          } else {
            return Text("You dont have any yet");
          }
        });
  }

  Widget _walletItem(BuildContext context, Wallet wallet) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          minimumSize: const Size(200, 120), //////// HERE
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AccountHistory(wallet: wallet)));
        },
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  wallet.accountName,
                  style: getStyle(20),
                ),
                const Spacer(),
                Text(
                  "${wallet.balance} kr",
                  style: getStyle(16),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  wallet.walletId.toString(),
                  textAlign: TextAlign.left,
                  style: getStyle(12),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle getStyle(double size) {
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: size,
    );
  }
}
