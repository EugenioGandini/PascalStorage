import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/settings_provider.dart';
import '../../../utils/notification_utils.dart';

class DeleteOfflineFilesLogout extends StatelessWidget {
  final bool deleteFileAtLogout;

  const DeleteOfflineFilesLogout({
    super.key,
    this.deleteFileAtLogout = false,
  });

  Future<void> _removeOfflineResourceAtLogout(BuildContext context) async {
    await _saveSettings(context, !deleteFileAtLogout);
  }

  Future _saveSettings(BuildContext context, bool remove) async {
    if (!context.mounted) return;

    var provider = Provider.of<SettingsProvider>(context, listen: false);

    await provider.deleteOfflineResourceAtLogout(remove);

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
        leading: const Icon(Icons.save),
        title: Text(AppLocalizations.of(context)!.removeOfflineFilesAtLogout),
        contentPadding: const EdgeInsets.only(
          bottom: 4,
          left: 16,
          right: 16,
        ),
        subtitle: Text(
          deleteFileAtLogout
              ? AppLocalizations.of(context)!.yes
              : AppLocalizations.of(context)!.no,
        ),
        onTap: () => _removeOfflineResourceAtLogout(context),
      ),
    );
  }
}
