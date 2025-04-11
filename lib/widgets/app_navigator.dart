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

        if (!_checkLoggedIn(context)) {
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
      case SharePage.routeName:
        if (currentRoute == SharePage.routeName) break;

        if (!_checkLoggedIn(context)) {
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
          break;
        }

        Navigator.of(context).pushReplacementNamed(SharePage.routeName);
        break;
      default:
        return;
    }
  }

  bool _checkLoggedIn(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return authProvider.isLoggedIn;
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
