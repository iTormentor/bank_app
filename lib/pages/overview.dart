import 'package:bank_app/pages/account_history.dart';
import 'package:flutter/material.dart';

import '../services/dummy_data.dart';

class Overview extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buildContent(context),
      ),
    );
  }

  List<Widget> buildContent(BuildContext context) {
    List<Widget> widgets = [SizedBox(height: 8)];
    for(Wallet wallet in DummyData.getInstance().getAllWalletsForUser(1)){
      widgets.add(ElevatedButton(
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AccountHistory(wallet: wallet))) ;
          }, child: Text("Hi")));
    }
    return widgets;
  }


}