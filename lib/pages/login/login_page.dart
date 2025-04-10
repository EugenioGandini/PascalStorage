import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/resource_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/logger.dart';

import 'widgets/cartel.dart';
import 'widgets/login_form.dart';

import '../page_background.dart';
import '../my_storage/my_storage_page.dart';
import '../offline/offline_page.dart';

class LoginPage extends StatelessWidget {
  final Logger _logger = const Logger('LoginPage');

  static const String routeName = '/login';

  const LoginPage({super.key});

  void _goToMyStorage(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    var syncAtLogin = settingsProvider.settings.syncAtLogin;

    if (syncAtLogin) {
      var resProvider = Provider.of<ResourceProvider>(context, listen: false);
      _logger.message('Sync at LOGIN');
      resProvider.syncFiles();
    }

    Navigator.of(context).pushReplacementNamed(MyStoragePage.routeName);
  }

  void _goToOfflinePage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(OfflinePage.routeName);
  }

  Widget _buildLoginTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Text(
        AppLocalizations.of(context)!.titleSignIn,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBackground(
        child: Center(
          child: Cartel(
            children: [
              _buildLoginTitle(context),
              LoginForm(
                onLoggedInSuccessfully: () => _goToMyStorage(context),
                onEnterOffline: () => _goToOfflinePage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
