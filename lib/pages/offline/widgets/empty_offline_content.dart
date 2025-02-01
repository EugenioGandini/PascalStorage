import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyOfflineContent extends StatelessWidget {
  const EmptyOfflineContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noOfflineFilesSaved,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noOfflineFileHint,
          ),
        ],
      ),
    );
  }
}
