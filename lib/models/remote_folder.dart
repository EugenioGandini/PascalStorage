import 'resource.dart';

class RemoteFolder extends Resource {
  RemoteFolder({
    required super.path,
    required super.name,
    required super.size,
    required super.modified,
    super.selected,
  });

  static fromJson(Map<String, Object?> json) {
    return RemoteFolder(
      path: json['path'] as String,
      name: json['name'] as String,
      size: json['size'] as int,
      modified: DateTime.parse(json['modified'] as String),
    );
  }

  RemoteFolder copyWith({
    bool selected = false,
  }) {
    return RemoteFolder(
      path: path,
      name: name,
      size: size,
      modified: modified,
      selected: selected,
    );
  }

  bool get isHome {
    return path == '' && name == 'Home';
  }
}
