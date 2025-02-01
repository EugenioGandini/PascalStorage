import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/pages.dart';
import '../config/colors.dart';

class DrawerWidget extends StatelessWidget {
  final BuildContext context;
  final String route;
  final Function(String selectedRoute) onNavigationSelected;
  final bool loggedIn;

  bool isCurrentPage(String routeName) {
    return routeName == route;
  }

  TextStyle getTextTheme(String routeName) {
    var theme = Theme.of(context).textTheme.bodyMedium;

    if (!isCurrentPage(routeName)) return theme!;

    return theme!.copyWith(fontWeight: FontWeight.bold);
  }

  Color? getBackgroundColor(String routeName) {
    if (!isCurrentPage(routeName)) return null;

    return AppColors.white;
  }

  const DrawerWidget(
    this.context, {
    super.key,
    required this.route,
    required this.onNavigationSelected,
    this.loggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    var myStorageTitlePage = AppLocalizations.of(context)!.settingsLabelRemote;

    if (!loggedIn) {
      myStorageTitlePage += ' - ${AppLocalizations.of(context)!.loginRequired}';
    }

    return Drawer(
      backgroundColor: AppColors.lightBlue2,
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: AppColors.blue,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pascal Storage',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  if (!loggedIn)
                    Text(
                      AppLocalizations.of(context)!.userNotLoggedIn,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: Text(
              myStorageTitlePage,
              style: getTextTheme(MyStoragePage.routeName),
            ),
            tileColor: getBackgroundColor(MyStoragePage.routeName),
            onTap: () => onNavigationSelected(MyStoragePage.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.wifi_off_outlined),
            title: Text(
              AppLocalizations.of(context)!.settingsLabelOffline,
              style: getTextTheme(OfflinePage.routeName),
            ),
            tileColor: getBackgroundColor(OfflinePage.routeName),
            onTap: () => onNavigationSelected(OfflinePage.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              AppLocalizations.of(context)!.settingsLabelSettings,
              style: getTextTheme(SettingsPage.routeName),
            ),
            tileColor: getBackgroundColor(SettingsPage.routeName),
            onTap: () => onNavigationSelected(SettingsPage.routeName),
          ),
        ],
      ),
    );
  }
}
