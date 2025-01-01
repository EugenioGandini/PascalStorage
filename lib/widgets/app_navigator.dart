import 'package:flutter/material.dart';

import '../pages/pages.dart';

import 'drawer_widget.dart';

class AppNavigator extends StatelessWidget {
  final String currentRoute;

  const AppNavigator({
    super.key,
    required this.currentRoute,
  });

  void _navigateToNewPage(BuildContext context, String route) {
    switch (route) {
      case MyStoragePage.routeName:
        if (currentRoute == MyStoragePage.routeName) return;
        Navigator.of(context).pushReplacementNamed(MyStoragePage.routeName);
      case SettingsPage.routeName:
        if (currentRoute == SettingsPage.routeName) return;
        Navigator.of(context).pushReplacementNamed(SettingsPage.routeName);
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DrawerWidget(
      context,
      route: currentRoute,
      onNavigationSelected: (route) => _navigateToNewPage(context, route),
    );
  }
}
