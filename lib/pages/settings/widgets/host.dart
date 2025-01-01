import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/settings_provider.dart';
import '../../../utils/notification_utils.dart';
import '../dialogs/dialog_new_host.dart';

class Host extends StatelessWidget {
  final String host;

  const Host({
    super.key,
    this.host = '',
  });

  Future<void> _changeHost(BuildContext context) async {
    String? newHost = await buildDialogNewHost(context, host);

    if (newHost == null) return;
    if (!context.mounted) return;

    await _saveSettings(context, newHost);
  }

  Future _saveSettings(BuildContext context, String newHost) async {
    if (!context.mounted) return;

    var provider = Provider.of<SettingsProvider>(context, listen: false);

    await provider.saveHost(newHost);

    if (!context.mounted) return;

    showSnackbar(
      context,
      const Icon(
        Icons.check,
        color: Colors.white,
      ),
      AppLocalizations.of(context)!.hostChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.http),
        title: Text(AppLocalizations.of(context)!.host),
        contentPadding: const EdgeInsets.only(
          bottom: 4,
          left: 16,
          right: 16,
        ),
        subtitle: Text(host),
        onTap: () => _changeHost(context),
      ),
    );
  }
}
