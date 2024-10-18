import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;

import 'package:http/http.dart' as http;

import '../../utils/platform.dart';
import '../../models/models.dart';
import '../../utils/logger.dart';

import './http_api.dart';

import '../base/resource_service.dart';

class ResourceServiceHttpImpl extends ResourceService {
  static const Logger _logger = Logger("ResourceService");

  String _baseUrl = '';
  Token? _token;

  void setHost(String host) {
    _baseUrl = host;
  }

  void updateToken(Token? newToken) {
    _token = newToken;
  }

  String? get jwt {
    return _token?.jwtBase64;
  }

  @override
  Future<FolderContent?> openFolder(RemoteFolder folder) async {
    try {
      final url = Uri.parse("$_baseUrl${HttpApi.loadResource}${folder.path}");
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Cookie': 'auth=$jwt',
        'X-Auth': jwt!
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

        if (percentage == 100) continue;

        yield percentage;
      }

      if (Platform.isWeb) {
        download(bytesBuilder.toBytes(), file.name);
      } else {
        await File('$dirOutput/${file.name}')
            .writeAsBytes(bytesBuilder.toBytes());
      }

      yield 100;
    } catch (error) {
      _logger.message("Failed to download the file $error");
    }
  }

  void download(
    List<int> bytes,
    String downloadName,
  ) {
    // Encode our file in base64
    final _base64 = base64Encode(bytes);
    // Create the link with the file
    final anchor = html.AnchorElement(
        href: 'data:application/octet-stream;base64,$_base64')
      ..target = 'blank';
    // add the name
    anchor.download = downloadName;
    // trigger download
    html.document.body!.append(anchor);
    anchor.click();
    anchor.remove();
    return;
  }

  @override
  Stream<int> uploadFile(
      Uint8List bufferFile, String remoteFolderPath, bool override) async* {
    try {
      final url = Uri.parse(
          "$_baseUrl${HttpApi.uploadResource}$remoteFolderPath?override=$override");
      final responsePost = await http.post(url, headers: {
        'Cookie': 'auth=$jwt',
        'X-Auth': jwt!,
      });

      if (responsePost.statusCode != 201) throw Exception();

      yield 10;

      final responseHead = await http.head(url, headers: {
        'Cookie': 'auth=$jwt',
        'X-Auth': jwt!,
      });

      if (responseHead.statusCode != 200) throw Exception();

      yield 20;

      var fileLenght = bufferFile.length;
      var bytes = bufferFile;

      final responsePatch = http
          .patch(
            url,
            headers: {
              'Content-Type': 'application/offset+octet-stream',
              'Cookie': 'auth=$jwt',
              'X-Auth': jwt!,
              'Content-Length': "$fileLenght",
              'Upload-Offset': "0",
            },
            body: bytes.toList(),
          )
          .asStream();

      await for (var response in responsePatch) {
        var offsetStr = response.headers['Upload-Offset'];
        if (offsetStr == null) continue;

        int offset = int.parse(offsetStr);

        int percentageUpload = (offset / fileLenght * 100).toInt();

        yield (percentageUpload * 80) ~/ 100;
      }

      yield 100;
    } catch (error) {
      _logger.message("Failed to upload the file $error");
    }
  }

  @override
  Future<bool> deleteFile(RemoteFile file) async {
    try {
      final url = Uri.parse("$_baseUrl${HttpApi.deleteResource}${file.path}");
      final response = await http.delete(url, headers: {
        'Cookie': 'auth=$jwt',
        'X-Auth': jwt!,
      });

      if (response.statusCode != 204) return false;

      return true;
    } catch (error) {
      _logger.message("Failed to delete the file $error");
    }

    return false;
  }

  @override
  Future<bool> moveFile(RemoteFile file, String destinationPath) async {
    try {
      final url =
          Uri.parse("$_baseUrl${HttpApi.moveResource}${file.path}?action=rename"
              "&destination=$destinationPath&override=false&rename=false");
      final response = await http.patch(url, headers: {
        'Cookie': 'auth=$jwt',
        'X-Auth': jwt!,
      });

      if (response.statusCode != 200) return false;

      return true;
    } catch (error) {
      _logger.message("Failed to move the file $error");
    }

    return false;
  }

  @override
  Future<bool> createFolder(String folderName, String parentFolderPath) async {
    try {
      final url = Uri.parse(
          "$_baseUrl${HttpApi.createFolder}$parentFolderPath/$folderName/");
      final responsePost = await http.post(url, headers: {
        'Cookie': 'auth=$jwt',
        'X-Auth': jwt!,
      });

      if (responsePost.statusCode != 200) return false;

      return true;
    } catch (error) {
      _logger.message("Failed to create the new folder $error");
    }

    return false;
  }

  @override
  Future<bool> moveFolder(RemoteFolder folder, String destinationPath) async {
    try {
      final url =
          Uri.parse("$_baseUrl${HttpApi.moveFolder}${folder.path}?action=rename"
              "&destination=$destinationPath&override=false&rename=false");
      final response = await http.patch(url, headers: {
        'Cookie': 'auth=$jwt',
        'X-Auth': jwt!,
      });

      if (response.statusCode != 200) return false;

      return true;
    } catch (error) {
      _logger.message("Failed to move the folder $error");
    }

    return false;
  }

  @override
  Future<bool> deleteFolder(RemoteFolder folder) async {
    try {
      final url = Uri.parse("$_baseUrl${HttpApi.deleteFolder}${folder.path}");
      final response = await http.delete(url, headers: {
        'Cookie': 'auth=$jwt',
        'X-Auth': jwt!,
      });

      if (response.statusCode != 204) return false;

      return true;
    } catch (error) {
      _logger.message("Failed to delete the folder $error");
    }

    return false;
  }
}
