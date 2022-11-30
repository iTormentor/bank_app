import 'package:flutter/material.dart';

import '../services/database.dart';
import '../services/dummy_data.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About me"),
      ),
    );
  }
}
