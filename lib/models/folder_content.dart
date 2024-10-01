import 'package:filebrowser/models/models.dart';

class FolderContent {
  String path = "";

  RemoteFolder currentFolder;
  List<RemoteFolder> folders = [];
  List<RemoteFile> files = [];

  FolderContent({
    required this.currentFolder,
  });
}
