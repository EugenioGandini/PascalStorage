import 'package:flutter/material.dart';

import '../../../models/models.dart';
import 'folder_widget.dart';

/// Widget for displaying folders in selection mode
class FolderSelectionWidget extends StatelessWidget {
  final RemoteFolder folder;

  /// When the user tap on this folder
  final VoidCallback? onTap;

  final bool isSelected;

  const FolderSelectionWidget({
    super.key,
    required this.folder,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return FolderWidget(
      folder: folder,
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
