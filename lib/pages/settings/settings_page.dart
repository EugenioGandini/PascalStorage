import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../page_background.dart';
import '../../../providers/settings_provider.dart';

import '../../widgets/app_navigator.dart';

import 'widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = '/settingsPage';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    var settings = provider.settings;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleSettings),
      ),
      drawer: const AppNavigator(currentRoute: SettingsPage.routeName),
      body: PageBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DefaultStoragePath(
                  defaultDownloadFolder: settings.defaultFolderDownload,
                ),
                DeleteOfflineFilesLogout(
                  deleteFileAtLogout: settings.deleteOfflineResourceAtLogout,
                ),
                OpenFileUponDownload(
                  openFile: settings.openFileUponDownload,
                ),
                SyncLogin(
                  syncAtLogin: settings.syncAtLogin,
                ),
                PeriodicSync(
                  periodicSync: settings.periodicSync,
                ),
                Host(
                  host: settings.host,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
