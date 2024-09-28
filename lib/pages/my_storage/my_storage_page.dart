import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:filebrowser/providers/resource_provider.dart';

import './folder_content_widget.dart';

class MyStoragePage extends StatelessWidget {
  static const String routeName = '/myStorage';

  const MyStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    var resProvider = Provider.of<ResourceProvider>(context);

    var currentFolder = resProvider.folder;
    var folderContent = resProvider.content;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Storage"),
      ),
      body: FolderContentWidget(
        folder: currentFolder,
        content: folderContent,
        onFolderTap: (folder) => resProvider.openFolder(folder),
        onFileTap: (file) => {},
      ),
    );
  }
}
