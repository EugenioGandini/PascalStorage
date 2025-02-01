import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/settings_provider.dart';
import '../../../utils/notification_utils.dart';

class SyncLogin extends StatelessWidget {
  final bool syncAtLogin;

  const SyncLogin({
    super.key,
    this.syncAtLogin = true,
  });

  Future<void> changeSyncAtLogin(BuildContext context) async {
    await _saveSettings(context, !syncAtLogin);
  }

  Future _saveSettings(BuildContext context, bool syncAtLogin) async {
    if (!context.mounted) return;

    var provider = Provider.of<SettingsProvider>(context, listen: false);

    await provider.changeSyncAtLogin(syncAtLogin);

    if (!context.mounted) return;

    showSnackbar(
      context,
      const Icon(
        Icons.check,
        color: Colors.white,
      ),
      AppLocalizations.of(context)!.behaviourChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.login),
        title: Text(AppLocalizations.of(context)!.syncAtLogin),
        contentPadding: const EdgeInsets.only(
          bottom: 4,
          left: 16,
          right: 16,
        ),
        subtitle: Text(
          syncAtLogin
              ? AppLocalizations.of(context)!.yes
              : AppLocalizations.of(context)!.no,
        ),
        onTap: () => changeSyncAtLogin(context),
      ),
    );
  }
}
