import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class MorePage extends StatelessWidget{
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.logout))
        ],
      ),
    );
  }


}