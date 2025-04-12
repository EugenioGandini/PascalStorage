import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/files_utils.dart';

/// Widget for displaying files
class FileWidget extends StatelessWidget {
  final String fileName;
  final String fileExtension;
  final DateTime? fileModified;
  final int? fileSize;

  /// When the user tap on this file
  final VoidCallback? onTap;

  /// When the user long press this file
  final VoidCallback? onLongPress;

  /// Optional trailing widget to insert at the end of this widget file
  final Widget? trailing;

  const FileWidget({
    super.key,
    required this.fileName,
    this.fileExtension = '',
    this.fileSize,
    this.fileModified,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  String get name {
    if (fileName.length < 26) return fileName;

    return '${fileName.substring(0, 23)}...';
  }

  Color _getSplashColor() {
    var color = getFileForegroundColor(fileExtension);

    return color.withAlpha(120);
  }

  @override
  Widget build(BuildContext context) {
    var subtitle = '';

    if (fileModified != null) {
      subtitle += DateFormat.yMMMd().add_jm().format(fileModified!.toLocal());
    }
    if (fileSize != null) {
      subtitle += " (${getFileSize(fileSize!)})";
    }

    return Card(
      color: getFileBackgroundColor(fileExtension),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: _getSplashColor(),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: Icon(
            getFileIcon(fileExtension),
            color: getFileForegroundColor(fileExtension),
          ),
          title: Text(
            name,
            style: TextStyle(
              color: getFileForegroundColor(fileExtension),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: getFileForegroundColor(fileExtension),
            ),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
