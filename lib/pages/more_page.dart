import 'package:bank_app/app/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class MorePage extends StatelessWidget{
  const MorePage({Key? key}) : super(key: key);


  Future<void> _signOut(BuildContext context) async {
    try {
      //await FirebaseAuth.instance.signOut();
      Navigator.of(context, rootNavigator: true).pop();
    } catch (e) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        actions: [
          IconButton(onPressed:() => { _signOut(context)}
            , icon: const Icon(Icons.logout))
        ],
      ),
    );
  }


}