import 'package:bank_app/pages/overview.dart';
import 'package:bank_app/pages/payment_page.dart';
import 'package:bank_app/pages/transfer_page.dart';
import 'package:bank_app/services/tab_item.dart';
import 'package:bank_app/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

import 'more_page.dart';

class HomePage extends StatefulWidget {
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
