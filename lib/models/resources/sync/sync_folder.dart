// import 'package:pascalstorage/models/resources/sync/location.dart';
// import 'package:pascalstorage/models/resources/sync/sync_action.dart';

// import 'resource_folder_sync.dart';
// import 'resource_file_sync.dart';

// class SyncFolder {
//   final ResourceFolderSync remoteFolder;
//   final ResourceFolderSync localFolder;
//   final String? name;

//   const SyncFolder({
//     required this.remoteFolder,
//     required this.localFolder,
//     this.name,
//   });

//   ResourceFolderSync getMergedFolder() {
//     List<ResourceFileSync> syncFiles = [];

//     syncFiles.addAll(localFolder.files.map((localFile) {
//       var remoteFile = remoteFolder.getFileWithName(localFile.name);

//       if (remoteFile == null ||
//           localFile.modified.isAfter(remoteFile.modified)) {
//         return ResourceFileSync(
//           file: localFile,
//           location: Location.local,
//           action: SyncAction.upload,
//         );
//       }
//     }));

//     syncFiles.addAll(remoteFolder.files.map((file) {
//       // TODO check in local
//     }));

//     List<ResourceFolderSync> syncFolders = [];

//     syncFolders.addAll(localFolder.subfolders.map((folder) {
//       // TODO check in remote
//     }));

//     syncFolders.addAll(remoteFolder.subfolders.map((folder) {
//       // TODO check in local
//     }));

//     var syncedFolder = localFolder.copyWith();

//     syncedFolder.files = syncFiles;
//     syncedFolder.subfolders = syncFolders;

//     return syncedFolder;
//   }
// }
