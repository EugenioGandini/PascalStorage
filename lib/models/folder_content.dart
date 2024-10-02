import 'package:filebrowser/models/models.dart';

class FolderContent {
  String path = "";

  RemoteFolder currentFolder;
  List<RemoteFolder> folders = [];
  List<RemoteFile> files = [];

  FolderContent({
    required this.currentFolder,
  });

  bool containsFileWithName(String fileName) {
    return files.any((file) => file.name == fileName);
  }
}
