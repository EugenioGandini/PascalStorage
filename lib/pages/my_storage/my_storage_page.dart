import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/platform.dart';
import '../../utils/logger.dart';
import '../../utils/storage_utils.dart';
import '../../utils/files_utils.dart';
import '../../config/permissions.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resource_provider.dart';
import '../login/login_page.dart';
import '../base_page.dart';

import 'dialogs/dialog_new.dart';
import 'dialogs/dialog_rename.dart';
import 'dialogs/dialog_yes_no.dart';
import 'widgets/file_details.dart';
import 'widgets/folder_details.dart';
import 'widgets/my_storage_app_bar.dart';
import 'folder_content_widget.dart';
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
  bool selectModeEnable = false;
  bool _init = false;
  String _title = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_init) return;

    _logger.message('Initialization page...');

    _resProvider = Provider.of<ResourceProvider>(context);

    var arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      _remoteFolder = arguments as RemoteFolder;
      var folderName = _remoteFolder.name;

      _updateTitle(folderName);

      _futureLoadFolder =
          _resProvider.openFolder(_remoteFolder).then((content) {
        _updateTitle(folderName, content: content);
        return content;
      });

      _logger.message('Loading folder ${_remoteFolder.name}');
    } else {
      var homeStorageTitle = AppLocalizations.of(context)!.titleMyStorage;

      _updateTitle(homeStorageTitle);
      _remoteFolder = _resProvider.homeFolder;

      _futureLoadFolder = _resProvider.loadHomeFolder().then((content) {
        _updateTitle(homeStorageTitle, content: content);
        return content;
      });

      _logger.message('Loading HOME folder');
    }

    _init = true;
  }

  void _updateTitle(String folderName, {FolderContent? content}) {
    String title = folderName;

    if (content != null && content.folderSize != 0) {
      title = "$title (${getHumanReadableSize(content.folderSize)})";
    }

    setState(() {
      _title = title;
    });
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
              onRename: (folder) => _selectNewNameFolder(folder),
              onDelete: (folder) => _deleteFolder(folder),
            ),
          ),
        );
      },
    );
  }

  /////// FILE operations ///////

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
      '${AppLocalizations.of(context)!.dialogDeleteMessage}?',
      titleHeading: const Icon(
        Icons.delete_forever,
        size: 32,
        color: Colors.red,
      ),
      centerChild: Text(
        file.name,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );

    if (!hasConfirmed) return;

    bool success = await _resProvider.deleteFile(file);

    if (success) {
      if (mounted) {
        notify.showDeleteResourceSuccess(context);
      }
      _forceReloadContent();
    }
  }

  Future _askSaveFile(RemoteFile file) async {
    var hasConfirmed = await askConfirmation(
      context,
      AppLocalizations.of(context)!.askDownloadFileTitle,
      AppLocalizations.of(context)!.askDownloadFileMessage,
      titleHeading: const Icon(
        Icons.download,
        size: 32,
      ),
      centerChild: Text(
        file.name,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );

    if (!hasConfirmed) return;

    String? downloadOutputFolder = await getDownloadFolder();

    if (downloadOutputFolder == null) return;

    _saveFile(file, downloadOutputFolder);
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

  /////// FOLDER operations ///////

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

  Future _deleteFolder(RemoteFolder folder) async {
    Navigator.of(context).pop();

    var hasConfirmed = await askConfirmation(
      context,
      AppLocalizations.of(context)!.dialogDeleteTitle,
      '${AppLocalizations.of(context)!.dialogDeleteMessage}?',
      titleHeading: const Icon(
        Icons.delete_forever,
        size: 32,
        color: Colors.red,
      ),
      centerChild: Text(
        folder.name,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );

    if (!hasConfirmed) return;

    bool success = await _resProvider.deleteFolder(folder);

    if (success) {
      if (mounted) {
        notify.showDeleteResourceSuccess(context);
      }
      _forceReloadContent();
    }
  }

  Future _selectNewNameFolder(RemoteFolder folder) async {
    Navigator.of(context).pop();

    bool renameSuccess =
        await buildDialogRenameResource(context, folderToBeRenamed: folder);

    if (renameSuccess) {
      if (mounted) {
        notify.showRenameResourceSuccess(context);
      }
      _forceReloadContent();
    }
  }

  void _forceReloadContent() {
    setState(() {
      var folderName = _remoteFolder.name;

      _futureLoadFolder =
          _resProvider.openFolder(_remoteFolder).then((content) {
        _updateTitle(folderName, content: content);
        return content;
      });
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

  /////// SELECT MODE ///////

  void _toggleSelectMode() {
    setState(() {
      _folderContent.toggleSelectMode();
      selectModeEnable = _folderContent.isSelectModeActive;
    });
  }

  void _toggleResourceSelection(RemoteFile fileSelected) {
    var updatedFile = fileSelected.copyWith(selected: !fileSelected.selected);

    setState(() {
      _folderContent.replaceFile(updatedFile);
    });
  }

  void _toggleFolderSelection(RemoteFolder folderSelected) {
    var updatedFolder =
        folderSelected.copyWith(selected: !folderSelected.selected);

    setState(() {
      _folderContent.replaceFolder(updatedFolder);
    });
  }

  void _toggleCheckAll() {
    setState(() {
      _folderContent.toggleSelectAllResources();
    });
  }

  Future _deleteSelectedResouces() async {
    bool success = await _resProvider.deleteSelectedResources(_folderContent);

    if (success) {
      _toggleSelectMode();

      if (mounted) {
        notify.showDeleteResourceSuccess(context);
      }
      _forceReloadContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: MyStorageAppBar(
        titleText: _title,
        onAdvancedActionPressed: _popupActionHandler,
        selectModeEnable: selectModeEnable,
        onDelete: _deleteSelectedResouces,
        onToggleCheckAll: _toggleCheckAll,
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

              return FolderContentWidget(
                folder: loadedContent.currentFolder,
                content: loadedContent,
                onFolderTap: (folder) {
                  if (selectModeEnable) {
                    _toggleFolderSelection(folder);
                  } else {
                    _openFolder(context, folder);
                  }
                },
                onFolderLongPress: (folder) =>
                    _openFolderDetails(context, folder),
                onFileLongPress: (file) => _openFileDetails(context, file),
                onFileTap: (file) {
                  if (selectModeEnable) {
                    _toggleResourceSelection(file);
                  } else {
                    _askSaveFile(file);
                  }
                },
                selectModeEnable: selectModeEnable,
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      selectFileToBeUploaded: _selectFileToBeUploaded,
      crateNewResource: _crateNewResource,
      toggleSelectMode: _toggleSelectMode,
    );
  }
}
