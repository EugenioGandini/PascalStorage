import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:filebrowser/models/models.dart';
import 'package:filebrowser/providers/resource_provider.dart';

import './folder_content_widget.dart';
import './file_details.dart';

class MyStoragePage extends StatefulWidget {
  static const String routeName = '/myStorage';

  const MyStoragePage({super.key});

  @override
  State<MyStoragePage> createState() => _MyStoragePageState();
}

class _MyStoragePageState extends State<MyStoragePage> {
  late Future _futureLoadFolder;
  late ResourceProvider resProvider;
  bool _init = false;
  String _title = 'My Storage';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_init) return;

    resProvider = Provider.of<ResourceProvider>(context, listen: false);

    var arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      RemoteFolder folderToLoad = arguments as RemoteFolder;
      _title = folderToLoad.name;
      _futureLoadFolder = resProvider.openFolder(folderToLoad);
    } else {
      _futureLoadFolder = resProvider.loadHomeFolder();
    }

    _init = true;
  }

  void _openFolder(BuildContext context, RemoteFolder folder) {
    Navigator.of(context).pushNamed(MyStoragePage.routeName, arguments: folder);
  }

  void _openFileDetails(BuildContext context, RemoteFile file) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FileDetails(
          file: file,
          onSaveFile: (dir) => _saveFile(file, dir),
        );
      },
    );
  }

  Future<void> _saveFile(RemoteFile file, String path) async {
    await for (final percentage in resProvider.downloadFile(file, path)) {
      print("Download $percentage %");
    }

    // TODO show toast success download
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: FutureBuilder(
        future: _futureLoadFolder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var loadedContent = snapshot.data as FolderContent;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: FolderContentWidget(
                folder: loadedContent.currentFolder,
                content: loadedContent,
                onFolderTap: (folder) => _openFolder(context, folder),
                onFileTap: (file) => _openFileDetails(
                  context,
                  file,
                ),
              ),
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
