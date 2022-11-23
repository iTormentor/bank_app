import 'package:bank_app/app/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class MorePage extends StatelessWidget{
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context, rootNavigator: true).pop();
          }, icon: const Icon(Icons.logout))
        ],
      ),
    );
  }


}