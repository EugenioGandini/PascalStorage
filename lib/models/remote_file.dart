import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_file.freezed.dart';
part 'remote_file.g.dart';

@Freezed(
  equal: false,
)
@JsonSerializable()
class RemoteFile with _$RemoteFile {
  const RemoteFile._();

  const factory RemoteFile({
    required String path,
    required String name,
    required int size,
    required DateTime modified,
    required String type,
    String? content,
    @Default(false) bool selected,
  }) = _RemoteFile;

  factory RemoteFile.fromJson(Map<String, Object?> json) =>
      _$RemoteFileFromJson(json);

  String get nameWithoutExtension {
    return name.substring(0, name.lastIndexOf("."));
  }

  String get extension {
    return name.split(".")[1];
  }

  String get parentPath {
    return path.substring(0, path.lastIndexOf('/'));
  }

  @override
  bool operator ==(Object other) {
    if (other is! RemoteFile) return false;
    var otherRemoteFile = other;

    return otherRemoteFile.path == path &&
        otherRemoteFile.name == name &&
        otherRemoteFile.modified == modified;
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, path, name, size, modified, type, content, selected);
}
