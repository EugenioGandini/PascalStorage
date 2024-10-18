import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/platform.dart';
import '../../utils/logger.dart';
import '../../config/permissions.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resource_provider.dart';
import '../login/login_page.dart';
import '../base_page.dart';

import './folder_content_widget.dart';
import './file_details.dart';
import './folder_details.dart';
import './dialog_new.dart';
import './dialog_rename.dart';
import './dialog_yes_no.dart';
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
  late ResourceProvider _resProvider;
  late RemoteFolder _remoteFolder;
  late FolderContent _folderContent;
  bool _init = false;
  String _title = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_init) return;

    _logger.message('Initialization page...');

    _resProvider = Provider.of<ResourceProvider>(context, listen: false);

    var arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      _remoteFolder = arguments as RemoteFolder;
      _title = _remoteFolder.name;
      _futureLoadFolder = _resProvider.openFolder(_remoteFolder);

      _logger.message('Loading folder ${_remoteFolder.name}');
    } else {
      _title = AppLocalizations.of(context)!.titleMyStorage;
      _remoteFolder = _resProvider.homeFolder;
      _futureLoadFolder = _resProvider.loadHomeFolder();

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
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: FileDetails(
              file: file,
              onSaveFile: (dir) {
                Navigator.of(context).pop();
                _saveFile(file, dir);
              },
              onMove: (file) => {}, //_selectNewFolderFile(file),
              onRename: (file) => _selectNewNameFile(file),
              onDelete: (file) => _deleteFile(file),
            ),
          ),
        );
      },
    );
  }

  void _openFolderDetails(BuildContext context, RemoteFolder folder) {
    _logger.message('User ask for details on folder ${folder.name}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: FolderDetails(
              folder: folder,
              // onSaveFile: (dir) {
              //   Navigator.of(context).pop();
              //   _saveFile(file, dir);
              // },
              // onMove: (file) => {}, //_selectNewFolderFile(file),
              onRename: (file) => {},
              onDelete: (file) => {},
            ),
          ),
        );
      },
    );
  }

  Future _saveFile(RemoteFile file, String path) async {
    _logger.message(
        'Saving remote file ${file.name} onto this device at path $path');

    await for (final percentage in _resProvider.downloadFile(file, path)) {
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
      withData: Platform.isWeb,
      allowMultiple: false,
      dialogTitle:
          mounted ? AppLocalizations.of(context)!.selectFileToBeUploaded : '',
    );

    if (result == null) return;

    PlatformFile filePath = result.files.single;

    late Uint8List buffer;
    late String fileFullName;

    if (Platform.isWeb) {
      _logger.message(
          'File selected ${filePath.name} ${filePath.bytes!.length} bytes');

      fileFullName = filePath.name;
      buffer = filePath.bytes!;
    } else {
      _logger.message('File selected ${filePath.path}');

      var fileToUpload = File(filePath.path!);

      fileFullName = path.basename(fileToUpload.path);
      buffer = await fileToUpload.readAsBytes();
    }

    await _uploadFile(fileFullName, buffer);
  }

  Future _uploadFile(String fileFullName, Uint8List buffer) async {
    _logger.message(
        'Uploading file $fileFullName to remote folder ${_remoteFolder.name}');

    var override = _folderContent.containsFileWithName(fileFullName);

    await for (var percentage in _resProvider.uploadFile(
        fileFullName, buffer, _remoteFolder, override)) {
      _logger.message('Uploading... $percentage %');

      if (percentage == 100) {
        _logger.message('Upload completed successfully !!!');

        notify.showUploadSuccess(context);

        _logger.message('Reloading folder content...');

        _forceReloadContent();
      }
    }
  }

  Future _deleteFile(RemoteFile file) async {
    Navigator.of(context).pop();

    var hasConfirmed = await askConfirmation(
        context,
        AppLocalizations.of(context)!.dialogDeleteTitle,
        '${AppLocalizations.of(context)!.dialogDeleteMessage} ${file.name}?');

    if (!hasConfirmed) return;

    bool success = await _resProvider.deleteFile(file);

    if (success) {
      if (mounted) {
        notify.showDeleteResourceSuccess(context);
      }
      _forceReloadContent();
    }
  }

  Future _selectNewNameFile(RemoteFile file) async {
    Navigator.of(context).pop();
    bool renameSuccess =
        await buildDialogRenameResource(context, fileToBeRenamed: file);

    if (renameSuccess) {
      if (mounted) {
        notify.showRenameResourceSuccess(context);
      }
      _forceReloadContent();
    }
  }

  Future _crateNewResource() async {
    bool newFolderSuccess =
        await buildDialogNewResource(context, _remoteFolder, true);

    if (newFolderSuccess) {
      if (mounted) {
        notify.showNewResourceCreatedSuccess(context);
      }
      _forceReloadContent();
    }
  }

  void _forceReloadContent() {
    setState(() {
      _futureLoadFolder = _resProvider.openFolder(_remoteFolder);
    });
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
      body: RefreshIndicator(
        onRefresh: () {
          _forceReloadContent();
          return _futureLoadFolder;
        },
        child: FutureBuilder(
          future: _futureLoadFolder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var loadedContent = snapshot.data as FolderContent;

              _folderContent = loadedContent;

              // setState(() {
              //   _title = "$_title ($_folderContent)";
              // });

              return FolderContentWidget(
                folder: loadedContent.currentFolder,
                content: loadedContent,
                onFolderTap: (folder) => _openFolder(context, folder),
                onFolderLongPress: (folder) =>
                    _openFolderDetails(context, folder),
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
      ),
      floatingActionButton: [
        FloatingActionButton(
          heroTag: 'UploadNewFile',
          onPressed: _selectFileToBeUploaded,
          child: const Icon(Icons.upload),
        ),
        FloatingActionButton(
          heroTag: 'CreateNewFolder',
          onPressed: _crateNewResource,
          child: const Icon(Icons.create_new_folder),
        ),
      ],
    );
  }
}
