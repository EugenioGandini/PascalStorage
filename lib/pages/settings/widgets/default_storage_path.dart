import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/settings_provider.dart';
import '../../../utils/storage_utils.dart';
import '../../../utils/notification_utils.dart';

class DefaultStoragePath extends StatelessWidget {
  final String defaultDownloadFolder;

  const DefaultStoragePath({
    super.key,
    this.defaultDownloadFolder = '',
  });

  Future<void> _changeFolder(BuildContext context) async {
    String? folderPath = await chooseOutputFolder();

    if (folderPath == null) return;
    if (!context.mounted) return;

    await _saveSettings(context, folderPath);
  }

  Future _resetFolder(BuildContext context) async {
    await _saveSettings(context, '');
  }

  Future _saveSettings(BuildContext context, String folderPath) async {
    if (!context.mounted) return;

    var provider = Provider.of<SettingsProvider>(context, listen: false);

    await provider.changeDefaultFolderDownload(folderPath);

    if (!context.mounted) return;

    showSnackbar(
      context,
      const Icon(
        Icons.check,
        color: Colors.white,
      ),
      AppLocalizations.of(context)!.defaultFolderDownloadChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCustom = defaultDownloadFolder.isNotEmpty;

    var location = isCustom
        ? defaultDownloadFolder
        : AppLocalizations.of(context)!.downloadFolder;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.folder),
        title: Text(AppLocalizations.of(context)!.defaultFolderDownload),
        trailing: isCustom
            ? IconButton(
                onPressed: () => _resetFolder(context),
                icon: const Icon(
                  Icons.restore,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.only(
          bottom: 4,
          left: 16,
          right: 16,
        ),
        subtitle: Text(location),
        onTap: () => _changeFolder(context),
      ),
    );
  }
}
