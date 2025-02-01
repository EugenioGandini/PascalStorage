import '../resource_file.dart';
import '../offline_file.dart';

import 'location.dart';
import 'sync_action.dart';

class ResourceFileSync {
  /// This must always be defined
  final OfflineFile dbFile;

  /// Can have a local copy
  final ResourceFile? localFile;

  /// Can have a remote copy
  final ResourceFile? remoteFile;

  ResourceFileSync({
    this.localFile,
    this.remoteFile,
    required this.dbFile,
  });

  /// If no local neither remote copy exists
  bool get isDangling {
    return localFile == null && remoteFile == null;
  }

  /// remote or local depending on physical existance
  Location? get location {
    var onLocale = localFile != null;
    var onRemote = remoteFile != null;

    if (onLocale && onRemote) return Location.both;

    if (onRemote) return Location.remote;

    if (onLocale) return Location.local;

    return null;
  }

  /// The action that should be performed based on existance and
  /// most recent modify date.
  SyncAction get action {
    if (location == Location.remote) return SyncAction.download;
    if (location == Location.local) return SyncAction.upload;

    if (location == Location.both) {
      var remoteNewer = remoteFile!.size != dbFile.remoteCopy.size;
      var localeNewer = localFile!.size != dbFile.localCopy.size;

      if (remoteNewer && localeNewer) {
        return SyncAction.ask;
      }

      if (remoteNewer) {
        return SyncAction.download;
      }

      if (localeNewer) {
        return SyncAction.upload;
      }
    }

    return SyncAction.noop;
  }

  @override
  String toString() {
    // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
    return 'file ${dbFile.remoteCopy.name} \n' +
        '\tsaved remotely ${dbFile.remoteCopy.parentPath} size ${dbFile.remoteCopy.size}\n' +
        '\tsaved locally ${dbFile.localCopy.path} size ${dbFile.localCopy.size}\n' +
        '\t${remoteFile != null ? 'remote new size ${remoteFile!.size}' : 'REMOTE MISSING'}\n' +
        '\t${localFile != null ? 'local new size ${localFile!.size}' : 'LOCAL MISSING'}';
  }
}
