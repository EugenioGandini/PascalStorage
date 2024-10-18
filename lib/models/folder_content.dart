import './models.dart';

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

  int get folderSize {
    return files.map((file) => file.size).reduce((accumulator, sizeFolder) {
      return accumulator + sizeFolder;
    });
  }
}
