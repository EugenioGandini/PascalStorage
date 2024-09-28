abstract class Resource {
  final String path;
  final String name;
  final int size;
  final DateTime modified;

  Resource({
    required this.path,
    required this.name,
    required this.size,
    required this.modified,
  });
}
