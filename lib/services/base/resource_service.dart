import 'package:filebrowser/models/models.dart';

abstract class ResourceService {
  Future<FolderContent?> openFolder(RemoteFolder folder);
  Stream<int> downloadFile(RemoteFile file, String dirOutput);
  // TODO ... Future<File> openFile(File file);
}
