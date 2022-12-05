import 'package:bank_app/pages/more_page.dart';
import 'package:bank_app/pages/overview.dart';
import 'package:bank_app/pages/transfer_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/payment_page.dart';
enum TabItem {
  overview,
  transfer,
  payment,
  more
}

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    Key? key,
    required this.currentTab,
    required this.onSelectedTab,
  }) : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.overview: (_) => const Overview(),
      TabItem.transfer: (_) => const Transfer(),
      TabItem.payment: (_) => const Payment(),
      TabItem.more: (_) => const MorePage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: currentTab.index,
        onTap: (index) => onSelectedTab(TabItem.values[index]),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Overview"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Transfer"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Payment"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "More"),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
            builder: (context) => widgetBuilders[item]!(context));
      },
    );
  }
}
