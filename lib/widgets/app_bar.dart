import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {

  String title;

  CustomAppBar(this.title, {Key? key}) : super(key: key);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }



}