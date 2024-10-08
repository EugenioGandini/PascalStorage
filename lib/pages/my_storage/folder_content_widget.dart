import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:filebrowser/models/models.dart';

import './file_widget.dart';
import './folder_widget.dart';

class FolderContentWidget extends StatelessWidget {
  final RemoteFolder folder;
  final FolderContent content;

  final Function(RemoteFolder folder) onFolderTap;
  final Function(RemoteFile file) onFileTap;

  final double maxWidthItem = 400;

  const FolderContentWidget({
    super.key,
    required this.folder,
    required this.content,
    required this.onFolderTap,
    required this.onFileTap,
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
        padding: const EdgeInsets.only(top: 8, bottom: 72, left: 8, right: 8),
        itemBuilder: (context, index) {
          if (index < content.folders.length) {
            var folder = content.folders[index];

            return FolderWidget(
              folder: folder,
              onTap: () => onFolderTap(folder),
            );
          }

          int indexFile = index - content.folders.length;

          var file = content.files[indexFile];

          return InkWell(
            child: FileWidget(
              file: file,
              onTap: () => onFileTap(file),
            ),
          );
        },
        itemCount: content.folders.length + content.files.length,
      ),
    );
  }
}
