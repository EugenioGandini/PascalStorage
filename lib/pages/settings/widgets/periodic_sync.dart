import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/settings_provider.dart';
import '../../../utils/notification_utils.dart';
import '../dialogs/dialog_new_duration.dart';

class PeriodicSync extends StatelessWidget {
  final Duration periodicSync;

  const PeriodicSync({
    super.key,
    this.periodicSync = Duration.zero,
  });

  Future<void> _changeFolder(BuildContext context) async {
    Duration? newFrequency =
        await buildDialogNewDuration(context, periodicSync);

    if (newFrequency == null) return;
    if (!context.mounted) return;

    await _saveSettings(context, newFrequency);
  }

  Future _resetPeriodSync(BuildContext context) async {
    await _saveSettings(context, Duration.zero);
  }

  Future _saveSettings(BuildContext context, Duration period) async {
    if (!context.mounted) return;

    var provider = Provider.of<SettingsProvider>(context, listen: false);

    await provider.changeSyncPeriod(period);

    if (!context.mounted) return;

    showSnackbar(
      context,
      const Icon(
        Icons.check,
        color: Colors.white,
      ),
      AppLocalizations.of(context)!.frequencySyncUpdated,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCustom = periodicSync != Duration.zero;

    var everyTimeMin = !isCustom ? "-" : "${periodicSync.inMinutes}";
    var everyTimeSec = !isCustom ? "-" : "${(periodicSync.inSeconds % 60)}";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.timer),
        title: Text(
          AppLocalizations.of(context)!
              .periodicSync(everyTimeMin, everyTimeSec),
        ),
        trailing: isCustom
            ? IconButton(
                onPressed: () => _resetPeriodSync(context),
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
        subtitle:
            Text(isCustom ? '' : AppLocalizations.of(context)!.syncDisable),
        onTap: () => _changeFolder(context),
      ),
    );
  }
}
