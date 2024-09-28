import 'package:filebrowser/models/models.dart';

abstract class ResourceService {
  Future<FolderContent?> openFolder(Folder folder);
  // TODO ... Future<File> openFile(File file);
}
