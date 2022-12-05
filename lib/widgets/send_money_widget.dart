import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';
import '../services/database.dart';

enum WidgetState { transfer, payment }

class MoveMoneyWidget extends StatefulWidget {
  const MoveMoneyWidget(WidgetState transfer, {Key? key}) : super(key: key);

  @override
  State<MoveMoneyWidget> createState() => _MoveMoneyWidgetState();
}

// The layout for sending money, including account selectors, amountTextField
// and the TransferButton.
// Will also be used for "Payment" tab later
class _MoveMoneyWidgetState extends State<MoveMoneyWidget> {
  _MoveMoneyWidgetState();

  Wallet? fromWallet;
  Wallet? toWallet;
  double? amount = 0.00;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildAccountSelectCard("From", "from"),
          _buildAccountSelectCard("To", "to"),
          const SizedBox(
            height: 20,
          ),
          _buildAmountTextField(),
          _confirmButton("Transfer")
        ],
      ),
    );
  }

  Widget _buildAmountTextField() {
    return Container(
      alignment: Alignment.center,
      child: Card(
        color: Colors.grey[300],
        child: SizedBox(width: 200,
          child: TextFormField(
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
              onChanged: (value) =>
              {amount = double.tryParse(value.replaceAll(",", ".")),
                amount = roundDouble(amount)}),
        ),
      ),
    );
  }

  // Builds the card to hold the dropdown, and calls function to
  // build the actual dropdown in child.
  Card _buildAccountSelectCard(String name, String key) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[300],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.red[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 50,
                child: Center(
                  child: Text(
                    name,
                    style: getTextStyle(18),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child:
              name == "From" ? _buildFromDropdown() : _buildToDropdown()),
        ],
      ),
    );
  }

  // Builds the dropdown menu for the "From" selector
  DropdownButtonHideUnderline _buildFromDropdown() {
    List<Wallet> walletList = Database.getInstance().cachedWallets;
    return DropdownButtonHideUnderline(
      child: DropdownButton<Wallet>(
        isExpanded: true,
        value: fromWallet,
        items: walletList.map<DropdownMenuItem<Wallet>>((value) {
          return DropdownMenuItem<Wallet>(
              value: value, child: _myDropDownItem(value));
        }).toList(),
        onChanged: (Wallet? item) {
          setState(() {
            fromWallet = item;
          });
        },
        hint: Row(
          children: const [Spacer(), Text("Select account"), Spacer()],
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
      ),
    );
  }

  //Builds the dropdown menu for the "To" dropdown
  DropdownButtonHideUnderline _buildToDropdown() {
    List<Wallet> walletList = Database.getInstance().cachedWallets;
    return DropdownButtonHideUnderline(
      child: DropdownButton<Wallet>(
        isExpanded: true,
        value: toWallet,
        items: walletList.map<DropdownMenuItem<Wallet>>((value) {
          return DropdownMenuItem<Wallet>(
              value: value, child: _myDropDownItem(value));
        }).toList(),
        onChanged: (Wallet? item) {
          setState(() {
            toWallet = item;
          });
        },
        hint: Row(
          children: const [Spacer(), Text("Select account"), Spacer()],
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
      ),
    );
  }

  // Builds the "Transfer" button
  Widget _confirmButton(String buttonText) {
    return ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
        onPressed: () {
          if (!checkValidInput(toWallet, fromWallet, amount)) {
            _transactionMessage(context, "Something went wrong",
                "Potential problems: \n\n * Amount is not a valid number\n"
                    " * You did not pick different accounts\n"
                    " * You don't have enough money");
          } else {
            Database.getInstance().createTransferTransaction(
                fromWallet!, toWallet!, amount!);
            _transactionMessage(context, "Transaction successful!", "");
          }
        },
        child: Text(
          buttonText,
          style: getTextStyle(22),
        ));
  }

  // Checks if the user has valid input before transferring money
  bool checkValidInput(Wallet? toWallet, Wallet? fromWallet, double? amount) {
    if (toWallet == null || fromWallet == null || amount == null) {
      return false;
    } else if (fromWallet.walletId == toWallet.walletId) {
      return false;
    } else if (fromWallet.balance < amount) {
      return false;
    }
    return true;
  }

  // Used to round the value in the "amount" textField to 2 decimals
  double? roundDouble(double? value) {
    num mod = pow(10, 2);
    if (value != null) {
      return ((value * mod).round().toDouble() / mod);
    }
    return null;
  }


  // Displays a dialog to tell the user if the transaction was
  // successful or not
  Future<void> _transactionMessage(BuildContext context, String title,
      String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme
                    .of(context)
                    .textTheme
                    .labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TextStyle getTextStyle(double size) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
  }

  // The layout/widget of one dropdown item in the dropdown menu
  DropdownMenuItem<Wallet> _myDropDownItem(Wallet wallet) {
    return DropdownMenuItem<Wallet>(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                wallet.accountName,
                style: getTextStyle(16),
              ),
              const Spacer(),
              Text(
                wallet.balance.toStringAsFixed(2),
                style: getTextStyle(16),
              )
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                wallet.walletId.toString(),
                style: getTextStyle(14),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}