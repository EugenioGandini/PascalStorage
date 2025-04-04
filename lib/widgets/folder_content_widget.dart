import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/models.dart';

import '../../utils/logger.dart';
import '../../utils/files_utils.dart';
import '../pages/my_storage/widgets/file_widget.dart';
import '../pages/my_storage/widgets/folder_widget.dart';
import '../pages/my_storage/widgets/folder_selection_widget.dart';
import '../pages/my_storage/widgets/file_selection_widget.dart';

/// Widget to display the content of a folder. A folder can contain:
/// - files
/// - other sub-folders
class FolderContentWidget extends StatelessWidget {
  final Logger _logger = const Logger('FolderContentWidget');

  final ResourceFolder folder;

  /// If the select mode is enabled or not
  final bool selectModeEnable;

  final Function(ResourceFolder folder)? onFolderTap;
  final Function(ResourceFolder folder)? onFolderLongPress;
  final Function(ResourceFile file)? onFileTap;
  final Function(ResourceFile file)? onFileLongPress;
  final Function(
    Resource source,
    ResourceFolder target,
  )? onResourceMoved;

  final double maxWidthItem = 430;

  const FolderContentWidget({
    super.key,
    required this.folder,
    this.onFolderTap,
    this.onFolderLongPress,
    this.onFileTap,
    this.onFileLongPress,
    this.onResourceMoved,
    this.selectModeEnable = false,
  });

  Widget _buildDraggable({
    required dynamic data,
  }) {
    late Widget feedbackWidget;

    if (data is ResourceFile) {
      var file = data;

      feedbackWidget = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 2,
              color: getFileBackgroundColor(file.extension),
            )),
        child: Icon(
          getFileIcon(file.extension),
          color: getFileBackgroundColor(file.extension),
          size: 32,
        ),
      );
    }
    if (data is ResourceFolder) {
      feedbackWidget = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 2,
              color: Colors.black,
            )),
        child: const Icon(
          Icons.folder,
          color: Colors.black,
          size: 32,
        ),
      );
    }
    return LongPressDraggable(
      data: data,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: feedbackWidget,
      child: const Icon(Icons.grid_view),
    );
  }

  Widget _buildFolderWidget(ResourceFolder subfolder) {
    if (selectModeEnable) {
      return FolderSelectionWidget(
        folderName: subfolder.name,
        folderModified: subfolder.modified,
        onTap: onFolderTap != null ? () => onFolderTap!(subfolder) : null,
        isSelected: subfolder.selected,
      );
    }

    return FolderWidget(
      folderName: subfolder.name,
      folderModified: subfolder.modified,
      onTap: onFolderTap != null ? () => onFolderTap!(subfolder) : null,
      trailing: _buildDraggable(
        data: subfolder,
      ),
      onLongPress: onFolderLongPress != null
          ? () => onFolderLongPress!(subfolder)
          : null,
    );
  }

  Widget _buildFileWidget(ResourceFile file) {
    if (selectModeEnable) {
      return FileSelectionWidget(
        fileName: file.name,
        fileExtension: file.extension,
        fileModified: file.modified,
        fileSize: file.size,
        onTap: onFileTap != null ? () => onFileTap!(file) : null,
        isSelected: file.selected,
      );
    }

    return FileWidget(
      fileName: file.name,
      fileExtension: file.extension,
      fileModified: file.modified,
      fileSize: file.size,
      onTap: onFileTap != null ? () => onFileTap!(file) : null,
      trailing: _buildDraggable(
        data: file,
      ),
      onLongPress:
          onFileLongPress != null ? () => onFileLongPress!(file) : null,
    );
  }

  void _handleDraggedEvent(DragTargetDetails details, ResourceFolder folder) {
    if (onResourceMoved == null) return;

    var dataDropped = details.data;

    if (dataDropped is ResourceFolder) {
      if (dataDropped == folder) {
        _logger.message('Dropped folder on the same folder. Skipping.');
        return;
      }

      _logger.message('folder dropped ${dataDropped.name} in ${folder.name}');

      onResourceMoved!(dataDropped, folder);
    }
    if (dataDropped is ResourceFile) {
      _logger.message('file dropped ${dataDropped.name} in ${folder.name}');

      onResourceMoved!(dataDropped, folder);
    }
  }

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

          Widget elementGrid;

          bool isSubfolder = index < subfolders.length;

          if (isSubfolder) {
            /// subfolder render widget

            var subfolder = subfolders[index];

            elementGrid = DragTarget(
                builder: (context, candidateData, rejectedData) {
                  var widgetFolder = _buildFolderWidget(subfolder);

                  if (candidateData.isNotEmpty) {
                    return Opacity(
                      opacity: .5,
                      child: widgetFolder,
                    );
                  }

                  return widgetFolder;
                },
                onWillAcceptWithDetails: (details) {
                  return true;
                },
                onAcceptWithDetails: (dragDetails) =>
                    _handleDraggedEvent(dragDetails, subfolder));
          } else {
            /// file render widget

            int indexFile = index - subfolders.length;

            var file = folder.files[indexFile];

            elementGrid = InkWell(child: _buildFileWidget(file));
          }

          return elementGrid;
        },
        itemCount: folder.subfolders.length + folder.files.length,
      ),
    );
  }
}
