import '../offline_file.dart';

class Sync {
  /// Unique assigned by the system - 0 -> standard download file
  final int id;
  final String name;

  final List<int> offlineFileIds;
  List<OfflineFile> offlineFiles = [];

  Sync({
    this.id = 0,
    this.name = '',
    required this.offlineFileIds,
  });

  Sync.defaultSync({
    this.offlineFileIds = const [],
  })  : id = 0,
        name = 'default_sync';

  Sync copyWith({
    int? addId,
    List<int>? withoutIds,
  }) {
    var fileIds = [...offlineFileIds];
    if (addId != null) fileIds.add(addId);
    if (withoutIds != null) {
      fileIds = fileIds.where((id) => !withoutIds.contains(id)).toList();
    }

    return Sync(
      id: id,
      name: name,
      offlineFileIds: fileIds,
    );
  }
}
