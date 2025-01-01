import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/settings_provider.dart';
import '../../../utils/notification_utils.dart';

class OpenFileUponDownload extends StatelessWidget {
  final bool openFile;

  const OpenFileUponDownload({
    super.key,
    this.openFile = true,
  });

  Future<void> _changeOpenFileUponDownload(BuildContext context) async {
    await _saveSettings(context, !openFile);
  }

  Future _saveSettings(BuildContext context, bool openFile) async {
    if (!context.mounted) return;

    var provider = Provider.of<SettingsProvider>(context, listen: false);

    await provider.changeOpenFileUponDownload(openFile);

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
        leading: const Icon(Icons.open_in_new),
        title: Text(AppLocalizations.of(context)!.openFileUponDownload),
        contentPadding: const EdgeInsets.only(
          bottom: 4,
          left: 16,
          right: 16,
        ),
        subtitle: Text(
          openFile
              ? AppLocalizations.of(context)!.yes
              : AppLocalizations.of(context)!.no,
        ),
        onTap: () => _changeOpenFileUponDownload(context),
      ),
    );
  }
}
