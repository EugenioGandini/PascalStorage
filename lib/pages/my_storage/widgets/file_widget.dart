import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/models.dart';
import '../../../utils/files_utils.dart';

/// Widget for displaying files
class FileWidget extends StatelessWidget {
  final RemoteFile file;

  /// When the user tap on this file
  final VoidCallback? onTap;

  /// When the user long press this file
  final VoidCallback? onLongPress;

  /// Optional trailing widget to insert at the end of this widget file
  final Widget? trailing;

  const FileWidget({
    super.key,
    required this.file,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  String get name {
    if (file.name.length < 26) return file.name;

    return '${file.name.substring(0, 23)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getFileBackgroundColor(file),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: ListTile(
          leading: Icon(
            getFileIcon(file),
            color: getFileForegroundColor(file),
          ),
          title: Text(
            name,
            style: TextStyle(
              color: getFileForegroundColor(file),
            ),
          ),
          subtitle: Text(
            "${DateFormat.yMMMd().add_jm().format(file.modified.toLocal())} (${getFileSize(file)})",
            style: TextStyle(
              fontSize: 12,
              color: getFileForegroundColor(file),
            ),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
