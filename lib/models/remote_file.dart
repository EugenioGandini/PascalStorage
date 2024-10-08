import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_file.freezed.dart';
part 'remote_file.g.dart';

@freezed
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
}
