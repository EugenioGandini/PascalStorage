import 'package:flutter/material.dart';

import '../../../models/remote_file.dart';
import 'file_widget.dart';

/// Widget for displaying files in selection mode
class FileSelectionWidget extends StatelessWidget {
  final RemoteFile file;

  /// When the user tap on this file
  final VoidCallback? onTap;

  final bool isSelected;

  const FileSelectionWidget({
    super.key,
    required this.file,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return FileWidget(
      file: file,
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
