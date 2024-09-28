import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder.freezed.dart';
part 'folder.g.dart';

@freezed
@JsonSerializable()
class Folder with _$Folder {
  const factory Folder({
    required String path,
    required String name,
    required int size,
    required DateTime modified,
  }) = _Folder;

  factory Folder.fromJson(Map<String, Object?> json) => _$FolderFromJson(json);
}
