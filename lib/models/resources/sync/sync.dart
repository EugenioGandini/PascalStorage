import '../offline_file.dart';

class Sync {
  /// Unique assigned by the system - 0 -> standard download file
  final int id;
  final String name;

  final List<int> offlineFileIds;
  List<OfflineFile> _offlineFiles = [];

  String? _filterKeyword;

  Sync({
    this.id = 0,
    this.name = '',
    required this.offlineFileIds,
  });

  List<OfflineFile> get offlineFiles {
    if (_filterKeyword == null) return _offlineFiles;

    return _offlineFiles
        .where((file) => file.localCopy.name
            .toLowerCase()
            .contains(_filterKeyword!.toLowerCase()))
        .toList();
  }

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

  void setOfflineFiles(List<OfflineFile> files) {
    _offlineFiles = files;
  }

  void applyFilter(String? filter) {
    _filterKeyword = filter;
  }
}
