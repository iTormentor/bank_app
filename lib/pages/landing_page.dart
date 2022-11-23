import 'package:bank_app/app/sign_in/sign_in_page.dart';
import 'package:bank_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  User? _user;

  void _updateUser(User user){
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_user == null){
    return SignInPage(
      onSignIn: (user) => _updateUser(user!),
    );
  } else {
      return HomePage();
    }
  }
}
