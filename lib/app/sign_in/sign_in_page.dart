import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../pages/home_page.dart';
import 'dart:developer';


class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.onSignIn});
  final void Function(User?) onSignIn;


  Future<void> _signInAnonymously() async{
    try {
      final userCredentials = await FirebaseAuth.instance.signInAnonymously();
      if(userCredentials.user != null) {
        onSignIn(userCredentials.user);
      }
    } on Exception catch (e) {
       print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bank App'),
        elevation: 10.0,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Image(image: AssetImage("assets/images/BankLogo.jpg")),
          const Text(
            "Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            child: const Text("Sign in with email"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
              HomePage()));
            },
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed:
              _signInAnonymously
            ,
            child: const Text("Sign in anonymously"),
          ),

        ],
      ),
    );
  }
}
