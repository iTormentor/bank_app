import 'package:bank_app/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.overview;

  @override
  Widget build(BuildContext context) {
    return CustomNavigationBar(currentTab: _currentTab, onSelectedTab: _choosePage);
  }

  void _choosePage(TabItem tabItem) {
     setState(() => _currentTab = tabItem);
  }
}
