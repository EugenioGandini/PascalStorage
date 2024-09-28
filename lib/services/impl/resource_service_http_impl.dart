import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:filebrowser/models/models.dart';
import 'package:filebrowser/utils/logger.dart';

import 'package:filebrowser/services/impl/http_api.dart';

import 'package:filebrowser/services/base/resource_service.dart';

class ResourceServiceHttpImpl extends ResourceService {
  static const Logger _logger = Logger("ResourceService");

  String _baseUrl = '';
  late Token _token;

  void setHost(String host) {
    _baseUrl = host;
  }

  void updateToken(Token newToken) {
    _token = newToken;
  }

  String get jwt {
    return _token.jwtBase64;
  }

  @override
  Future<FolderContent?> openFolder(Folder folder) async {
    try {
      final url = Uri.parse("$_baseUrl${HttpApi.loadResource}${folder.path}");
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Cookie': 'auth=$jwt',
        'X-Auth': jwt
      });

      if (response.statusCode != 200) return null;

      var mapBody = jsonDecode(response.body) as Map<String, dynamic>;

      var listItems = mapBody['items'] as List<dynamic>;

      FolderContent content = FolderContent(currentFolder: folder);

      for (var item in listItems) {
        bool isDirectory = item['isDir'] as bool;

        if (isDirectory) {
          content.folders.add(Folder.fromJson(item));
        } else {
          content.files.add(File.fromJson(item));
        }
      }

      return content;
    } catch (error) {
      _logger.message("Failed to load folder content");
    }

    return null;
  }
}
