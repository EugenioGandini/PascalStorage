import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FailLoadContent extends StatelessWidget {
  const FailLoadContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.errorLoadContent,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            AppLocalizations.of(context)!.errorLoadContentHint,
          ),
        ],
      ),
    );
  }
}
