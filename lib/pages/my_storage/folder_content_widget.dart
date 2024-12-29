import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pascalstorage/pages/my_storage/widgets/folder_selection_widget.dart';

import '../../models/models.dart';

import 'widgets/file_widget.dart';
import 'widgets/file_selection_widget.dart';
import 'widgets/folder_widget.dart';

/// Widget to display the content of a folder. A folder can contain:
/// - files
/// - other sub-folders
class FolderContentWidget extends StatelessWidget {
  final RemoteFolder folder;
  final FolderContent content;

  /// If the select mode is enabled or not
  final bool selectModeEnable;

  final Function(RemoteFolder folder) onFolderTap;
  final Function(RemoteFolder folder) onFolderLongPress;
  final Function(RemoteFile file) onFileTap;
  final Function(RemoteFile file) onFileLongPress;

  final double maxWidthItem = 430;

  const FolderContentWidget({
    super.key,
    required this.folder,
    required this.content,
    required this.onFolderTap,
    required this.onFolderLongPress,
    required this.onFileTap,
    required this.onFileLongPress,
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
          if (index < content.folders.length) {
            var folder = content.folders[index];

            return selectModeEnable
                ? FolderSelectionWidget(
                    folder: folder,
                    onTap: () => onFolderTap(folder),
                    isSelected: folder.selected,
                  )
                : FolderWidget(
                    folder: folder,
                    onTap: () => onFolderTap(folder),
                    onLongPress: () => onFolderLongPress(folder),
                  );
          }

          int indexFile = index - content.folders.length;

          var file = content.files[indexFile];

          return InkWell(
            child: selectModeEnable
                ? FileSelectionWidget(
                    file: file,
                    onTap: () => onFileTap(file),
                    isSelected: file.selected,
                  )
                : FileWidget(
                    file: file,
                    onTap: () => onFileTap(file),
                    onLongPress: () => onFileLongPress(file),
                  ),
          );
        },
        itemCount: content.folders.length + content.files.length,
      ),
    );
  }
}
