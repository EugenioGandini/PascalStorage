import 'resource_file.dart';

class OfflineFile {
  final int? id;

  final ResourceFile localCopy;
  final ResourceFile remoteCopy;
  final bool synchronize;

  OfflineFile({
    this.id,
    required this.localCopy,
    required this.remoteCopy,
    this.synchronize = false,
  });

  OfflineFile copyWith({
    int? id,
    ResourceFile? localCopy,
    ResourceFile? remoteCopy,
    bool? synchronize,
  }) {
    return OfflineFile(
      id: id ?? this.id,
      localCopy: localCopy ?? this.localCopy,
      remoteCopy: remoteCopy ?? this.remoteCopy,
      synchronize: synchronize ?? this.synchronize,
    );
  }

  @override
  String toString() {
    // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
    return 'Offline file ${remoteCopy.name} id $id\n' +
        '\tRemote time ${remoteCopy.modified} size ${remoteCopy.size}\n' +
        '\tLocal time ${localCopy.modified} size ${localCopy.size}';
  }
}
