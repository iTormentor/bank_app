import 'package:bank_app/pages/landing_page.dart';
import 'package:bank_app/services/dummy_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DummyData.getInstance().initializeDummyData();
  await Firebase.initializeApp();
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
      home: LandingPage(),
    );
  }
}