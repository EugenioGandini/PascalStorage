import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_folder.freezed.dart';
part 'remote_folder.g.dart';

@Freezed(
  equal: false,
)
@JsonSerializable()
class RemoteFolder with _$RemoteFolder {
  const RemoteFolder._();

  const factory RemoteFolder({
    required String path,
    required String name,
    required int size,
    required DateTime modified,
    @Default(false) bool selected,
  }) = _RemoteFolder;

  factory RemoteFolder.fromJson(Map<String, Object?> json) =>
      _$RemoteFolderFromJson(json);

  String get parentPath {
    return path.substring(0, path.lastIndexOf('/'));
  }

  @override
  bool operator ==(Object other) {
    if (other is! RemoteFolder) return false;
    var otherRemoteFile = other;

    return otherRemoteFile.path == path &&
        otherRemoteFile.name == name &&
        otherRemoteFile.modified == modified;
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, path, name, size, modified, selected);
}
