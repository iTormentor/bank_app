import 'package:bank_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:bank_app/app/sign_in/sign_in_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: "BankApp",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const SignInPage(),
    );
  }
}