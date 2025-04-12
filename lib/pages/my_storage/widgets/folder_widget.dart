import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/colors.dart';

/// Widget for displaying folders
class FolderWidget extends StatelessWidget {
  final String folderName;
  final DateTime? folderModified;

  /// When the user tap on this folder
  final VoidCallback? onTap;

  /// When the user long press this folder
  final VoidCallback? onLongPress;

  final Widget? trailing;

  const FolderWidget({
    super.key,
    required this.folderName,
    this.folderModified,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  Color _getSplashColor() {
    var color = AppColors.deepBlue;

    return color.withAlpha(120);
  }

  @override
  Widget build(BuildContext context) {
    var subtitle = folderModified != null
        ? DateFormat.yMMMd().add_jm().format(folderModified!.toLocal())
        : '';

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: _getSplashColor(),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: const Icon(Icons.folder),
          title: Text(folderName),
          subtitle: Text(
            subtitle,
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
