import 'package:filebrowser/models/models.dart';

class FolderContent {
  String path = "";

  Folder currentFolder;
  List<Folder> folders = [];
  List<File> files = [];

  FolderContent({
    required this.currentFolder,
  });
}
