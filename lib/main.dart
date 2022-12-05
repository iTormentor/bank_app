import 'package:bank_app/pages/home_page.dart';
import 'package:bank_app/pages/sign_in/auth_screen.dart';
import 'package:bank_app/services/dummy_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DummyData.getInstance().initializeDummyData();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// Login-page pulled and modified from https://github.com/TarekAlabd/Authentication-With-Amazing-UI-Flutter
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
      home: const AuthScreen(authType: AuthType.login),
      routes: {
        'home': (context) => const HomePage(),
        'login': (context) => const AuthScreen(authType: AuthType.login),
        'register': (context) => const AuthScreen(authType: AuthType.register),
      }
    );
  }
}