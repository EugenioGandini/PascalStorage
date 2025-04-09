import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/colors.dart';
import '../../widgets/app_navigator.dart';
import '../page_background.dart';
import 'offline_page.dart';

class ScaffoldPage extends StatelessWidget {
  final Widget child;

  final bool searchModeEnable;

  final VoidCallback onForceSync;
  final Function(bool enable) onSearch;
  final Function(String keyword) onFilterElements;

  final FocusNode focusNodeSearchInput;

  const ScaffoldPage({
    super.key,
    required this.child,
    required this.focusNodeSearchInput,
    this.searchModeEnable = false,
    required this.onForceSync,
    required this.onSearch,
    required this.onFilterElements,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchModeEnable
            ? Form(
                child: TextFormField(
                  focusNode: focusNodeSearchInput,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.hintSearchIn(
                      AppLocalizations.of(context)!.titleOfflinePage,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: AppColors.deepBlue,
                      ),
                      onPressed: () => onSearch(false),
                    ),
                  ),
                  onChanged: onFilterElements,
                ),
              )
            : Text(AppLocalizations.of(context)!.titleOfflinePage),
        actions: [
          if (!searchModeEnable) ...[
            IconButton(
              onPressed: () => onSearch(true),
              icon: const Icon(
                Icons.search,
              ),
            ),
            IconButton(
              onPressed: onForceSync,
              icon: const Icon(Icons.sync),
            ),
          ]
        ],
      ),
      drawer: const AppNavigator(currentRoute: OfflinePage.routeName),
      body: PageBackground(child: child),
    );
  }
}
