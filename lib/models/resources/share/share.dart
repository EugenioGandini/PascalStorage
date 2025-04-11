class Share {
  String path;
  String hash;
  DateTime expire;

  Share({
    required this.path,
    required this.hash,
    required this.expire,
  });

  static fromJson(Map<String, dynamic> jsonMap) {
    return Share(
      path: jsonMap['path'],
      hash: jsonMap['hash'],
      expire: DateTime.fromMillisecondsSinceEpoch(jsonMap['expire'] * 1000),
    );
  }
}
