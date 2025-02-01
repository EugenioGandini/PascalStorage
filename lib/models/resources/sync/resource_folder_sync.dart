import '../resource_folder.dart';
import 'location.dart';
import 'sync_action.dart';

class ResourceFolderSync extends ResourceFolder {
  final Location location;
  final SyncAction action;

  ResourceFolderSync({
    required this.location,
    required this.action,
    required super.path,
    required super.name,
    required super.size,
    required super.modified,
    super.selected,
  });
}
