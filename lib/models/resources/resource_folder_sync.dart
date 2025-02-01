import 'resource.dart';
import 'sync/resource_file_sync.dart';

class ResourceFolderSync extends Resource {
  List<ResourceFolderSync> subfolders = [];
  List<ResourceFileSync> files = [];

  ResourceFolderSync({
    required super.path,
    required super.name,
    required super.size,
    required super.modified,
    super.selected,
  });
}
