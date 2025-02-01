import '../../models/models.dart';

abstract class SyncService {
  Future syncResources();
  Future addOfflineFileToSync({
    required ResourceFile remoteFile,
    required String localPath,
    Sync? sync,
  });
  Future updateOfflineFileSync(OfflineFile updatedOfflineFile, {Sync? sync});
  Future removeOfflineFileFromSync(List<OfflineFile> offlineFiles);
}
