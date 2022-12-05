import 'package:bank_app/pages/account_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),
        actions: [
          IconButton(
            onPressed: () {
              _newAccountDialog(context);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [buildContent(context), const SizedBox(height: 50)],
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return StreamBuilder<List<Wallet>>(
        stream: Database.getInstance().getWallets(),
        builder: (context, snapshot) {
          bool? empty = snapshot.data?.isEmpty;
          if (snapshot.hasData && !empty!) {
            return Column(
              children: snapshot.data!
                  .map<Widget>((wallet) => _walletItem(context, wallet))
                  .toList(),
            );
          } if(snapshot.hasError){
            return _showNoAccounts();
          }
            else {
            return _showNoAccounts();
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
                const Spacer(),
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

  Widget _showNoAccounts() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Card(
          color: Colors.grey[400],
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Icon(
                IconData(0xf655,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage),
              ),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    "Seems like you don't have any accounts opened yet!",
                    style: getStyle(16),
                  ),
                  const Spacer()
                ],
              ),
              Text(
                "Click the plus sign to apply for an account",
                style: getStyle(16),
              ),
              const SizedBox(height: 16),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _newAccountDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        bool spendingAccount = true;
        String accountName = "";
        return AlertDialog(
          title: const Text(
            'Create new account',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Account name",
                ),
                onChanged: (value) {
                  accountName = value;
                },
              ),
              Row(
                children: [
                  const Text("Spending account:"),
                  const Spacer(),
                  Checkbox(
                    value: spendingAccount,
                    onChanged: (bool? value) {
                      setState(() {
                        spendingAccount = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Database.getInstance().createWallet(accountName,spendingAccount);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
