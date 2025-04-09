import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../config/colors.dart';

class MyStorageAppBar extends AppBar {
  final BuildContext context;

  final String titleText;

  final bool selectModeEnable;
  final bool searchModeEnable;

  final Function(String action) onAdvancedActionPressed;
  final VoidCallback onDelete;
  final VoidCallback onToggleCheckAll;
  final VoidCallback onDownload;
  final Function(bool enable) onSearch;
  final Function(String keyword) onFilterElements;

  final FocusNode focusNodeSearchInput;

  MyStorageAppBar({
    super.key,
    required this.context,
    required this.focusNodeSearchInput,
    required this.titleText,
    required this.onAdvancedActionPressed,
    required this.onDelete,
    required this.onToggleCheckAll,
    required this.onDownload,
    required this.onSearch,
    required this.onFilterElements,
    this.selectModeEnable = false,
    this.searchModeEnable = false,
  }) : super(
          title: searchModeEnable
              ? Form(
                  child: TextFormField(
                    focusNode: focusNodeSearchInput,
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context)!.hintSearchIn(titleText),
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
              : Text(titleText),
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
                  if (!searchModeEnable)
                    IconButton(
                      onPressed: () => onSearch(true),
                      icon: const Icon(
                        Icons.search,
                      ),
                    ),
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
