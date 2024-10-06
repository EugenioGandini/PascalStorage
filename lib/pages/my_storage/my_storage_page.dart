import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/logger.dart';
import '../../config/permissions.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resource_provider.dart';
import '../login/login_page.dart';
import '../base_page.dart';

import './folder_content_widget.dart';
import './file_details.dart';
import 'notifications.dart' as notify;

class MyStoragePage extends StatefulWidget {
  static const String routeName = '/myStorage';

  const MyStoragePage({super.key});

  @override
  State<MyStoragePage> createState() => _MyStoragePageState();
}

class _MyStoragePageState extends State<MyStoragePage> {
  final Logger _logger = const Logger('MyStoragePage');

  late Future _futureLoadFolder;
  late ResourceProvider resProvider;
  late RemoteFolder _remoteFolder;
  late FolderContent _folderContent;
  bool _init = false;
  String _title = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_init) return;

    _logger.message('Initialization page...');

    resProvider = Provider.of<ResourceProvider>(context, listen: false);

    var arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      _remoteFolder = arguments as RemoteFolder;
      _title = _remoteFolder.name;
      _futureLoadFolder = resProvider.openFolder(_remoteFolder);

      _logger.message('Loading folder ${_remoteFolder.name}');
    } else {
      _title = AppLocalizations.of(context)!.titleMyStorage;
      _remoteFolder = resProvider.homeFolder;
      _futureLoadFolder = resProvider.loadHomeFolder();

      _logger.message('Loading HOME folder');
    }

    _init = true;
  }

  void _openFolder(BuildContext context, RemoteFolder folder) {
    _logger.message('User navigate to folder ${folder.name}');

    Navigator.of(context).pushNamed(MyStoragePage.routeName, arguments: folder);
  }

  void _openFileDetails(BuildContext context, RemoteFile file) {
    _logger.message('User opened file ${file.name}');

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: FileDetails(
            file: file,
            onSaveFile: (dir) {
              _saveFile(file, dir);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  Future _saveFile(RemoteFile file, String path) async {
    _logger.message(
        'Saving remote file ${file.name} onto this device at path $path');

    await for (final percentage in resProvider.downloadFile(file, path)) {
      _logger.message('Download $percentage %');

      if (percentage == 100) {
        _logger.message('Donwload completed succesfully!!!');

        notify.showDownloadSuccess(context);
      }
    }
  }

  Future _selectFileToBeUploaded() async {
    if (!await hasStorageAccessPermission()) return;

    _logger.message('Selecting file to upload');

    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      dialogTitle: AppLocalizations.of(context)!.selectFileToBeUploaded,
    );

    if (result == null) return;

    List<PlatformFile> filePath = result.files;
    _logger.message('File selected ${filePath[0].path}');

    var fileToUpload = File(filePath[0].path!);

    await _uploadFile(fileToUpload);
  }

  Future _uploadFile(File file) async {
    _logger.message(
        'Uploading file ${file.path} to remote folder ${_remoteFolder.name}');

    var fileName = path.basename(file.path);
    var override = _folderContent.containsFileWithName(fileName);

    await for (var percentage
        in resProvider.uploadFile(file, _remoteFolder, override)) {
      _logger.message('Uploading... $percentage %');

      if (percentage == 100) {
        _logger.message('Upload completed successfully !!!');

        notify.showUploadSuccess(context);

        _logger.message('Reloading folder content...');

        setState(() {
          _futureLoadFolder = resProvider.openFolder(_remoteFolder);
        });
      }
    }
  }

  void _popupActionHandler(String option) {
    if (option == 'logout') {
      _logout();
    }
  }

  void _logout() {
    _logger.message('Logging out user...');

    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var navigator = Navigator.of(context);

    authProvider.logout().then((ignored) {
      _logger.message('Logout completed. Redirecting to login page');

      navigator.pushReplacementNamed(LoginPage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          PopupMenuButton<String>(
            onSelected: _popupActionHandler,
            itemBuilder: (context) {
              return {'logout'}.map((action) {
                return PopupMenuItem(
                  value: action,
                  child: Text(AppLocalizations.of(context)!.exit),
                );
              }).toList();
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _futureLoadFolder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var loadedContent = snapshot.data as FolderContent;

            _folderContent = loadedContent;

            return FolderContentWidget(
              folder: loadedContent.currentFolder,
              content: loadedContent,
              onFolderTap: (folder) => _openFolder(context, folder),
              onFileTap: (file) => _openFileDetails(
                context,
                file,
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectFileToBeUploaded,
        child: const Icon(Icons.upload),
      ),
    );
  }
}
