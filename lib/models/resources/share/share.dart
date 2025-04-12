class Share {
  String path;
  String hash;
  DateTime expire;

  Share({
    required this.path,
    required this.hash,
    required this.expire,
  });

  String get name {
    return path.split('/').where((level) => level.isNotEmpty).last;
  }

  String get extension {
    return name.split('.').last;
  }

  bool get isFolder {
    return !name.contains('.');
  }

  static fromJson(Map<String, dynamic> jsonMap) {
    return Share(
      path: jsonMap['path'],
      hash: jsonMap['hash'],
      expire: DateTime.fromMillisecondsSinceEpoch(jsonMap['expire'] * 1000),
    );
  }
}
