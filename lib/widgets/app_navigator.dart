import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
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
        if (currentRoute == MyStoragePage.routeName) break;

        var authProvider = Provider.of<AuthProvider>(context, listen: false);

        bool isLoggedIn = authProvider.isLoggedIn;

        if (!isLoggedIn) {
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
          break;
        }

        Navigator.of(context).pushReplacementNamed(MyStoragePage.routeName);
        break;
      case SettingsPage.routeName:
        if (currentRoute == SettingsPage.routeName) break;
        Navigator.of(context).pushReplacementNamed(SettingsPage.routeName);
        break;
      case OfflinePage.routeName:
        if (currentRoute == OfflinePage.routeName) break;
        Navigator.of(context).pushReplacementNamed(OfflinePage.routeName);
        break;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    bool isLoggedIn = authProvider.isLoggedIn;

    return DrawerWidget(
      context,
      route: currentRoute,
      onNavigationSelected: (route) => _navigateToNewPage(context, route),
      loggedIn: isLoggedIn,
    );
  }
}
