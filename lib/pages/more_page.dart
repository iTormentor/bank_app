import 'package:bank_app/app/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import 'about_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('login');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        actions: [
          IconButton(
              onPressed: () => {_signOut(context)},
              icon: const Icon(Icons.logout))
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [_menuItem("About me", SizedBox(), context)],
    );
  }

  Widget _menuItem(String title, Widget page, BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size.fromHeight(60),
        ),
        onPressed: () {Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AboutPage()));
        },
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_right_alt_rounded,
              color: Colors.black,
            )
          ],
        ));
  }
}
