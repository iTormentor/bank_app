import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/sign_in/auth_screen.dart';
import '../services/auth.dart';
import '../services/database.dart';
import 'my_button.dart';

class AuthForm extends StatefulWidget {
  final AuthType authType;

  const AuthForm({Key? key, required this.authType}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  AuthBase authBase = AuthBase();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter your email',
                hintText: 'ex: test@gmail.com',
              ),
              onChanged: (value) {
                _email = value;
              },
              validator: (value) =>
              (value != null && value.isEmpty) ? 'You must enter a valid email' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter your password',
              ),
              obscureText: true,
              onChanged: (value) {
                _password = value;
              },
              validator: (value) => value != null && value.length <= 6
                  ? 'Your password must be larger than 6 characters'
                  : null,
            ),
            const SizedBox(height: 20),
            MyButton(
              text: widget.authType == AuthType.login ? 'Login' : 'Register',
              color: Colors.deepPurple,
              textColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (widget.authType == AuthType.login) {
                    dynamic result = await authBase.loginWithEmailAndPassword(_email, _password);
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if(currentUser != null) {
                      Database.getInstance().uid = currentUser.uid;
                      Navigator.of(context).pushReplacementNamed('home');
                    } else {
                      Database.getInstance().uid = "";
                        _loginFailedAlert(context, "login", result);
                    }
                  } else {
                    dynamic result = await authBase.registerWithEmailAndPassword(_email, _password);
                    if(FirebaseAuth.instance.currentUser?.uid != null) {
                      Navigator.of(context).pushReplacementNamed('home');
                    } else {
                      _loginFailedAlert(context, "register", result);
                    }
                  }
                }
              },
            ),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: () {
                if (widget.authType == AuthType.login) {
                  Navigator.of(context).pushReplacementNamed('register');
                  print(widget.authType);
                } else {
                  Navigator.of(context).pushReplacementNamed('login');
                }
              },
              child: Text(
                widget.authType == AuthType.login
                    ? 'Don\'t have an account?'
                    : 'Already have an account?',
                style: const TextStyle(fontSize: 16,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginFailedAlert(BuildContext context, String type, dynamic result) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Failed to $type'),
          content: Text(result.message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
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
}


