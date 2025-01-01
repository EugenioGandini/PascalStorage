import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/pages.dart';
import '../config/colors.dart';

class DrawerWidget extends StatelessWidget {
  final BuildContext context;
  final String route;
  final Function(String selectedRoute) onNavigationSelected;

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
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.lightBlue2,
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: AppColors.blue,
            child: Center(
              child: Text(
                'Pascal Storage',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: Text(
              AppLocalizations.of(context)!.settingsLabelRemote,
              style: getTextTheme(MyStoragePage.routeName),
            ),
            tileColor: getBackgroundColor(MyStoragePage.routeName),
            onTap: () => onNavigationSelected(MyStoragePage.routeName),
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
