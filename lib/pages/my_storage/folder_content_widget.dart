import 'package:flutter/material.dart';

import 'package:filebrowser/models/models.dart';

import './file_widget.dart';
import './folder_widget.dart';

class FolderContentWidget extends StatelessWidget {
  final Folder folder;
  final FolderContent content;

  final Function(Folder folder) onFolderTap;
  final Function(File file) onFileTap;

  const FolderContentWidget({
    super.key,
    required this.folder,
    required this.content,
    required this.onFolderTap,
    required this.onFileTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        childAspectRatio: 3,
      ),
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
            onTap: () {},
          ),
        );
      },
      itemCount: content.folders.length + content.files.length,
    );
  }
}
