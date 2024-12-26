import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyStorageAppBar extends AppBar {
  final String titleText;
  final bool selectModeEnable;
  final Function(String action)? onAdvancedActionPressed;

  MyStorageAppBar({
    super.key,
    required this.titleText,
    this.onAdvancedActionPressed,
    this.selectModeEnable = false,
  }) : super(
          title: Text(titleText),
          actions: selectModeEnable
              ? [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                    ),
                    color: Colors.red[400],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_downward_rounded,
                    ),
                    color: Colors.blue[900],
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
