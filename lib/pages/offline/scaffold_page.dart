import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/app_navigator.dart';
import '../page_background.dart';
import 'offline_page.dart';

class ScaffoldPage extends StatefulWidget {
  /// The body of the scaffold of the settings page.
  final Widget body;

  /// Callback invoked when the user ask forcely a sync with the remote.
  final VoidCallback onForceSync;

  /// Callback invoked when the user is filtering elements by an entered keyword.
  final Function(String? keyword) onFilterElements;

  const ScaffoldPage({
    super.key,
    required this.body,
    required this.onForceSync,
    required this.onFilterElements,
  });

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  final FocusNode _focusNodeSearchInput = FocusNode();
  bool _searchModeEnable = false;

  void _onSearch(bool enable) {
    setState(() {
      _searchModeEnable = enable;

      if (enable) {
        _focusNodeSearchInput.requestFocus();
      } else {
        widget.onFilterElements(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchModeEnable
            ? Form(
                child: TextFormField(
                  focusNode: _focusNodeSearchInput,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.hintSearchIn(
                      AppLocalizations.of(context)!.titleOfflinePage,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.black,
                      ),
                      onPressed: () => _onSearch(false),
                    ),
                  ),
                  onChanged: widget.onFilterElements,
                ),
              )
            : Text(AppLocalizations.of(context)!.titleOfflinePage),
        actions: [
          if (!_searchModeEnable) ...[
            IconButton(
              onPressed: () => _onSearch(true),
              icon: const Icon(
                Icons.search,
              ),
            ),
            IconButton(
              onPressed: widget.onForceSync,
              icon: const Icon(Icons.sync),
            ),
          ]
        ],
      ),
      drawer: const AppNavigator(currentRoute: OfflinePage.routeName),
      body: PageBackground(child: widget.body),
    );
  }
}
