import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/pages.dart';
import '../config/colors.dart';

class NavigationRails extends StatelessWidget {
  final String route;
  final Function(String selectedRoute) onNavigationSelected;

  const NavigationRails({
    super.key,
    required this.route,
    required this.onNavigationSelected,
  });

  int get index {
    switch (route) {
      case MyStoragePage.routeName:
        return 0;
      case SettingsPage.routeName:
        return 1;
      default:
        return 0;
    }
  }

  void _navigateToNewPage(BuildContext context, int indexSelected) {
    switch (indexSelected) {
      case 0:
        onNavigationSelected(MyStoragePage.routeName);
      case 1:
        onNavigationSelected(SettingsPage.routeName);
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: NavigationRail(
        selectedIndex: index,
        labelType: NavigationRailLabelType.all,
        elevation: 22,
        groupAlignment: 0,
        backgroundColor: AppColors.lightBlue2,
        selectedLabelTextStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontWeight: FontWeight.bold),
        unselectedLabelTextStyle: Theme.of(context).textTheme.bodyMedium,
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.cloud),
            label: Text(AppLocalizations.of(context)!.settingsLabelRemote),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings),
            label: Text(AppLocalizations.of(context)!.settingsLabelSettings),
          ),
        ],
        onDestinationSelected: (index) => _navigateToNewPage(context, index),
      ),
    );
  }
}
