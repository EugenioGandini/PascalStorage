import 'dart:convert';

class Token {
  String jwtBase64;
  DateTime? expiration;
  bool isAdmin = false;
  bool canCreate = false;
  bool canRename = false;
  bool canModify = false;
  bool canDelete = false;
  bool canShare = false;
  bool canDownload = false;

  Token({
    required this.jwtBase64,
  });

  void decode() {
    var codec = const Base64Codec();
    var payloadString = codec.decode(codec.normalize(jwtBase64.split('.')[1]));

    var mapValues =
        jsonDecode(String.fromCharCodes(payloadString)) as Map<String, dynamic>;

    expiration =
        DateTime.fromMillisecondsSinceEpoch((mapValues['exp'] as int) * 1000);

    var mapPermissions = mapValues['user']['perm'] as Map<String, dynamic>;

    isAdmin = mapPermissions['admin'] as bool;
    canCreate = mapPermissions['create'] as bool;
    canRename = mapPermissions['rename'] as bool;
    canModify = mapPermissions['modify'] as bool;
    canDelete = mapPermissions['delete'] as bool;
    canShare = mapPermissions['share'] as bool;
    canDownload = mapPermissions['download'] as bool;
  }

  bool get needRefresh {
    if (expiration == null) return true;
    return DateTime.now().add(const Duration(minutes: 30)).isAfter(expiration!);
  }
}
