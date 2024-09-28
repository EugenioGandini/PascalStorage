import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:filebrowser/models/models.dart';
import 'package:filebrowser/providers/resource_provider.dart';

import './folder_content_widget.dart';

class MyStoragePage extends StatelessWidget {
  static const String routeName = '/myStorage';

  const MyStoragePage({super.key});

  void openFolder(BuildContext context, Folder folder) {
    Navigator.of(context).pushNamed(routeName, arguments: folder);
  }

  @override
  Widget build(BuildContext context) {
    var resProvider = Provider.of<ResourceProvider>(context);

    var arguments = ModalRoute.of(context)!.settings.arguments;

    String title = 'My Storage';

    Future future;
    if (arguments != null) {
      Folder folderToLoad = arguments as Folder;
      title = folderToLoad.name;
      future = resProvider.openFolder(folderToLoad);
    } else {
      future = resProvider.loadHomeFolder();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var loadedContent = snapshot.data as FolderContent;
            return FolderContentWidget(
              folder: loadedContent.currentFolder,
              content: loadedContent,
              onFolderTap: (folder) => openFolder(context, folder),
              onFileTap: (file) => {},
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
