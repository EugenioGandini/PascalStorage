import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/models.dart';

import '../pages/my_storage/widgets/file_widget.dart';
import '../pages/my_storage/widgets/folder_widget.dart';
import '../pages/my_storage/widgets/folder_selection_widget.dart';
import '../pages/my_storage/widgets/file_selection_widget.dart';

/// Widget to display the content of a folder. A folder can contain:
/// - files
/// - other sub-folders
class FolderContentWidget extends StatelessWidget {
  final ResourceFolder folder;

  /// If the select mode is enabled or not
  final bool selectModeEnable;

  final Function(ResourceFolder folder)? onFolderTap;
  final Function(ResourceFolder folder)? onFolderLongPress;
  final Function(ResourceFile file)? onFileTap;
  final Function(ResourceFile file)? onFileLongPress;

  final double maxWidthItem = 430;

  const FolderContentWidget({
    super.key,
    required this.folder,
    this.onFolderTap,
    this.onFolderLongPress,
    this.onFileTap,
    this.onFileLongPress,
    this.selectModeEnable = false,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // print(width);

    var maxCrossAxisExtent = maxWidthItem;

    var columns = (width / maxCrossAxisExtent).ceil();
    var aspectRatio = (width / 90.21) / columns;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 96, left: 8, right: 8),
        itemBuilder: (context, index) {
          var subfolders = folder.subfolders;

          if (index < subfolders.length) {
            var subfolder = subfolders[index];

            return selectModeEnable
                ? FolderSelectionWidget(
                    folderName: subfolder.name,
                    folderModified: subfolder.modified,
                    onTap: onFolderTap != null
                        ? () => onFolderTap!(subfolder)
                        : null,
                    isSelected: subfolder.selected,
                  )
                : FolderWidget(
                    folderName: subfolder.name,
                    folderModified: subfolder.modified,
                    onTap: onFolderTap != null
                        ? () => onFolderTap!(subfolder)
                        : null,
                    onLongPress: onFolderLongPress != null
                        ? () => onFolderLongPress!(subfolder)
                        : null,
                  );
          }

          int indexFile = index - subfolders.length;

          var file = folder.files[indexFile];

          return InkWell(
            child: selectModeEnable
                ? FileSelectionWidget(
                    fileName: file.name,
                    fileExtension: file.extension,
                    fileModified: file.modified,
                    fileSize: file.size,
                    onTap: onFileTap != null ? () => onFileTap!(file) : null,
                    isSelected: file.selected,
                  )
                : FileWidget(
                    fileName: file.name,
                    fileExtension: file.extension,
                    fileModified: file.modified,
                    fileSize: file.size,
                    onTap: onFileTap != null ? () => onFileTap!(file) : null,
                    onLongPress: onFileLongPress != null
                        ? () => onFileLongPress!(file)
                        : null,
                  ),
          );
        },
        itemCount: folder.subfolders.length + folder.files.length,
      ),
    );
  }
}
