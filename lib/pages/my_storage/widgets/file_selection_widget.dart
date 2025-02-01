import 'package:flutter/material.dart';

import 'file_widget.dart';

/// Widget for displaying files in selection mode
class FileSelectionWidget extends StatelessWidget {
  final String fileName;
  final String fileExtension;
  final DateTime? fileModified;
  final int? fileSize;

  /// When the user tap on this file
  final VoidCallback? onTap;

  final bool isSelected;

  const FileSelectionWidget({
    super.key,
    required this.fileName,
    this.fileExtension = '',
    this.fileSize,
    this.fileModified,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return FileWidget(
      fileName: fileName,
      fileExtension: fileExtension,
      fileModified: fileModified,
      fileSize: fileSize,
      onTap: onTap,
      trailing: Transform.scale(
        scale: 1.5,
        child: Checkbox(
          value: isSelected,
          onChanged: (state) {
            if (state == null) return;
            onTap!();
          },
        ),
      ),
    );
  }
}
