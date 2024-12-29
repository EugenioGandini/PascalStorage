import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyStorageAppBar extends AppBar {
  final String titleText;
  final bool selectModeEnable;
  final Function(String action) onAdvancedActionPressed;
  final VoidCallback onDelete;
  final VoidCallback onToggleCheckAll;
  final VoidCallback onDownload;

  MyStorageAppBar({
    super.key,
    required this.titleText,
    required this.onAdvancedActionPressed,
    required this.onDelete,
    required this.onToggleCheckAll,
    required this.onDownload,
    this.selectModeEnable = false,
  }) : super(
          title: Text(titleText),
          actions: selectModeEnable
              ? [
                  IconButton(
                    onPressed: onToggleCheckAll,
                    icon: const Icon(
                      Icons.checklist,
                    ),
                  ),
                  IconButton(
                    onPressed: onDownload,
                    icon: const Icon(
                      Icons.download,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                ]
              : [
                  PopupMenuButton<String>(
                    onSelected: onAdvancedActionPressed,
                    itemBuilder: (context) {
                      return {'logout'}.map((action) {
                        return PopupMenuItem(
                          value: action,
                          child: Text(AppLocalizations.of(context)!.exit),
                        );
                      }).toList();
                    },
                  ),
                ],
        );
}
