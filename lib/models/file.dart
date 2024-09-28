import 'package:freezed_annotation/freezed_annotation.dart';

part 'file.freezed.dart';
part 'file.g.dart';

@freezed
@JsonSerializable()
class File with _$File {
  const File._();

  const factory File({
    required String path,
    required String name,
    required int size,
    required DateTime modified,
    required String type,
    String? content,
  }) = _File;

  factory File.fromJson(Map<String, Object?> json) => _$FileFromJson(json);

  String get extension {
    return name.split(".")[1];
  }
}
