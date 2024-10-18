import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_folder.freezed.dart';
part 'remote_folder.g.dart';

@freezed
@JsonSerializable()
class RemoteFolder with _$RemoteFolder {
  const RemoteFolder._();

  const factory RemoteFolder({
    required String path,
    required String name,
    required int size,
    required DateTime modified,
  }) = _RemoteFolder;

  factory RemoteFolder.fromJson(Map<String, Object?> json) =>
      _$RemoteFolderFromJson(json);

  String get parentPath {
    return path.substring(0, path.lastIndexOf('/'));
  }
}
