import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.folder_open,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noContent,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noContentHint,
          ),
        ],
      ),
    );
  }
}
