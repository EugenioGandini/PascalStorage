import 'resource.dart';

class RemoteFile extends Resource {
  final String type;
  String? content;

  RemoteFile({
    required super.path,
    required super.name,
    required super.size,
    required super.modified,
    required this.type,
    this.content,
    super.selected,
  });

  static fromJson(Map<String, Object?> json) {
    return RemoteFile(
      path: json['path'] as String,
      name: json['name'] as String,
      size: json['size'] as int,
      modified: DateTime.parse(json['modified'] as String),
      type: json['type'] as String,
      content: json['content'] as String?,
    );
  }

  RemoteFile copyWith({
    bool selected = false,
  }) {
    return RemoteFile(
      path: path,
      name: name,
      size: size,
      modified: modified,
      type: type,
      content: content,
      selected: selected,
    );
  }

  String get nameWithoutExtension {
    return name.substring(0, name.lastIndexOf("."));
  }

  String get extension {
    if (!name.contains('.')) return '';
    return name.split(".").last;
  }
}
