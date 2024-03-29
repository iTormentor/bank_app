import 'package:flutter/material.dart';
import '../../widgets/send_money_widget.dart';


class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transfer"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: MoveMoneyWidget(WidgetState.transfer),
      ),
    );
  }


}

