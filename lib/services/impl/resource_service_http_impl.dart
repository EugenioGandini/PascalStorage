import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
  Future<FolderContent?> openFolder(RemoteFolder folder) async {
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
          content.folders.add(RemoteFolder.fromJson(item));
        } else {
          content.files.add(RemoteFile.fromJson(item));
        }
      }

      return content;
    } catch (error) {
      _logger.message("Failed to load folder content");
    }

    return null;
  }

  @override
  Stream<int> downloadFile(RemoteFile file, String dirOutput) async* {
    try {
      final url = Uri.parse(
          "$_baseUrl${HttpApi.downloadResource}${file.path}?auth=$jwt&inline=true");
      final responseStream = http.get(
        url,
        headers: {"Transfer-Encoding": "chunked"},
      ).asStream();

      int percentage = 0;

      BytesBuilder bytesBuilder = BytesBuilder();

      await for (final response in responseStream) {
        int? totalBytes = response.contentLength;
        int numBytes = response.bodyBytes.length;

        if (totalBytes == null) continue;

        var deltaPercentage = ((numBytes / totalBytes) * 100).toInt();

        percentage = percentage + deltaPercentage;

        bytesBuilder.add(response.bodyBytes);

        yield percentage;
      }

      await File('$dirOutput/${file.name}')
          .writeAsBytes(bytesBuilder.toBytes());

      yield 100;
    } catch (error) {
      _logger.message("Failed to download the file");
    }
  }
}
