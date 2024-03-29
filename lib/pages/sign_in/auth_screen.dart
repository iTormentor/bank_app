import 'package:flutter/material.dart';

import '../../widgets/auth_form.dart';

enum AuthType { login, register }

class AuthScreen extends StatelessWidget {
  final AuthType authType;

  const AuthScreen({Key? key, required this.authType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Banken"),),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 65),
            const Center(
              child: Hero(
                tag: 'logoAnimation',
                child: Image(image: AssetImage("assets/images/BankLogo.jpg"))
              ),
            ),
            AuthForm(authType: authType, key: const Key("Auth"),),
          ],
        ),
      ),
    );
  }
}
