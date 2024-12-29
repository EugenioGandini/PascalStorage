abstract class Resource {
  final String path;
  final String name;
  final int size;
  final DateTime modified;
  bool selected;

  Resource({
    required this.path,
    required this.name,
    required this.size,
    required this.modified,
    this.selected = false,
  });

  String get parentPath {
    return path.substring(0, path.lastIndexOf('/'));
  }

  @override
  bool operator ==(Object other) {
    if (other is! Resource) return false;
    var otherRemoteFile = other;

    return otherRemoteFile.path == path &&
        otherRemoteFile.name == name &&
        otherRemoteFile.modified == modified;
  }

  @override
  int get hashCode => Object.hash(runtimeType, path, name, modified);
}
