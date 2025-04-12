import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoShares extends StatelessWidget {
  const NoShares({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.share,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noShares,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.hintShareResources,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
