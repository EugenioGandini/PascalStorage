import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/resource_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/logger.dart';

import '../../config/colors.dart';
import '../base_page.dart';
import './login_form.dart';

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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: Center(
        child: Container(
          width: 350,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                offset: Offset(10, 10),
                blurRadius: 20,
              )
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 24,
                ),
                child: Text(
                  AppLocalizations.of(context)!.titleSignIn,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
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
