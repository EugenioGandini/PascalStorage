import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/models.dart';

import '../pages/my_storage/widgets/file_widget.dart';
import '../pages/my_storage/widgets/file_selection_widget.dart';

/// Widget to display the content of a folder. A folder can contain:
/// - files
/// - other sub-folders
class SyncContentWidget extends StatelessWidget {
  final Sync syncContent;

  /// If the select mode is enabled or not
  final bool selectModeEnable;

  final Function(OfflineFile file)? onFileTap;
  final Function(OfflineFile file)? onFileLongPress;

  final double maxWidthItem = 430;

  const SyncContentWidget({
    super.key,
    required this.syncContent,
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
          var file = syncContent.offlineFiles[index];

          return InkWell(
            child: selectModeEnable
                ? FileSelectionWidget(
                    fileName: file.localCopy.name,
                    fileExtension: file.localCopy.extension,
                    fileModified: file.localCopy.modified,
                    fileSize: file.localCopy.size,
                    onTap: onFileTap != null ? () => onFileTap!(file) : null,
                  )
                : FileWidget(
                    fileName: file.localCopy.name,
                    fileExtension: file.localCopy.extension,
                    fileModified: file.localCopy.modified,
                    fileSize: file.localCopy.size,
                    onTap: onFileTap != null ? () => onFileTap!(file) : null,
                    onLongPress: onFileLongPress != null
                        ? () => onFileLongPress!(file)
                        : null,
                    trailing: file.synchronize
                        ? const Icon(
                            Icons.sync,
                            size: 25,
                          )
                        : null,
                  ),
          );
        },
        itemCount: syncContent.offlineFiles.length,
      ),
    );
  }
}
