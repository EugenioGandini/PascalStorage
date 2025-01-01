import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/models.dart';
import '../../utils/utilities.dart';
import '../../config/permissions.dart';
import '../../providers/settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resource_provider.dart';
import '../login/login_page.dart';
import '../base_page.dart';

import '../../widgets/app_navigator.dart';
import 'widgets/widgets.dart';
import 'dialogs/dialogs.dart';
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
  bool _canShowDrawer = false;
  String _title = '';
  late Settings _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_init) return;

    _logger.message('Initialization page...');

    _resProvider = Provider.of<ResourceProvider>(context);
    _settings = Provider.of<SettingsProvider>(context, listen: false).settings;

    var arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      _remoteFolder = arguments as RemoteFolder;
      var folderName = _remoteFolder.name;

      _updateTitle(folderName);

      _futureLoadFolder =
          _resProvider.openFolder(_remoteFolder).then((content) {
        setState(() {
          _updateTitle(folderName, content: content);
          _updateDrawer(_remoteFolder.isHome);
        });

        return content;
      });

      _logger.message('Loading folder ${_remoteFolder.name}');
    } else {
      var homeStorageTitle = AppLocalizations.of(context)!.titleMyStorage;

      _updateTitle(homeStorageTitle);
      _remoteFolder = _resProvider.homeFolder;

      _futureLoadFolder = _resProvider.loadHomeFolder().then((content) {
        setState(() {
          _updateTitle(homeStorageTitle, content: content);
          _updateDrawer(_remoteFolder.isHome);
        });

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

    _title = title;
  }

  void _updateDrawer(bool isHomeFolder) {
    _canShowDrawer = isHomeFolder;
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
              onSaveFile: (dir) async {
                Navigator.of(context).pop();

                await _saveFile([file], dir);

                if (!_settings.openFileUponDownload) return;

                OpenFile.open(path.join(dir, file.name));
              },
              onMove: (file) => {}, //_selectNewFolderFile(file),
              onRename: (file) => _selectNewName(file),
              onDelete: (file) {
                Navigator.of(context).pop();
                _deleteRemoteResource([file]);
              },
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
              onRename: (folder) => _selectNewName(folder),
              onDelete: (folder) {
                Navigator.of(context).pop();
                _deleteRemoteResource([folder]);
              },
            ),
          ),
        );
      },
    );
  }

  Future _selectNewName(Resource resource) async {
    Navigator.of(context).pop();

    bool renameSuccess =
        await buildDialogRenameResource(context, resourceToBeRenamed: resource);

    if (renameSuccess) {
      if (mounted) {
        notify.showRenameResourceSuccess(context);
      }
      _forceReloadContent();
    }
  }

  Future _deleteRemoteResource(List<Resource> resources) async {
    String message = resources[0].name;
    int numResources = resources.length;

    if (numResources > 1) {
      int numFiles = resources.whereType<RemoteFile>().length;
      int numFolders = resources.whereType<RemoteFolder>().length;

      List<String> messageParts = [];
      if (numFiles > 0) messageParts.add('$numFiles file');
      if (numFolders > 0) messageParts.add('$numFolders cartelle');
      message = messageParts.join('\n');
    }

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
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );

    if (!hasConfirmed) return;

    bool success = await _resProvider.deleteRemoteResource(resources);

    if (success) {
      if (mounted) {
        notify.showDeleteResourceSuccess(
          context,
          resource: numResources == 1 ? resources[0] : null,
        );
      }
      _forceReloadContent();
    }
  }

  /////// FILE operations ///////

  Future _saveFile(List<Resource> remoteResources, String path) async {
    for (var resource in remoteResources) {
      if (resource is! RemoteFile) continue;

      _logger.message(
          'Saving remote file ${resource.name} onto this device at path $path');

      await for (final percentage
          in _resProvider.downloadFile(resource, path)) {
        _logger.message('Download $percentage %');

        if (percentage == 100) {
          _logger.message('Download completed succesfully!!!');

          notify.showDownloadSuccess(context);
        }
      }
    }
  }

  Future _selectFileToBeUploaded() async {
    if (!await hasStorageAccessPermission()) return;

    _logger.message('Selecting file to upload');

    var result = await FilePicker.platform.pickFiles(
      withData: Platform.isWeb,
      allowMultiple: true,
      dialogTitle:
          mounted ? AppLocalizations.of(context)!.selectFileToBeUploaded : '',
    );

    if (result == null) return;

    for (var file in result.files) {
      PlatformFile filePath = file;

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

  Future _askSaveFile(List<Resource> resources) async {
    String message = resources[0].name;
    int numResources = resources.length;

    if (numResources > 1) {
      int numFiles = resources.whereType<RemoteFile>().length;
      int numFolders = resources.whereType<RemoteFolder>().length;

      List<String> messageParts = [];
      if (numFiles > 0) messageParts.add('$numFiles file');
      if (numFolders > 0) messageParts.add('$numFolders cartelle');
      message = messageParts.join('\n');
    }

    var hasConfirmed = await askConfirmation(
      context,
      AppLocalizations.of(context)!.askDownloadTitle,
      AppLocalizations.of(context)!.askDownloadMessage,
      titleHeading: const Icon(
        Icons.download,
        size: 32,
      ),
      centerChild: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );

    if (!hasConfirmed) return;

    if (!context.mounted) return;
    var customDestination = _settings.defaultFolderDownload;

    String? outputFolder = customDestination.isNotEmpty
        ? customDestination
        : await getDownloadFolder();

    if (outputFolder == null) return;

    await _saveFile(resources, outputFolder);

    if (numResources == 1 && _settings.openFileUponDownload) {
      await OpenFile.open(
        path.join(outputFolder, resources[0].name),
      );
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

  /////// Actions ///////

  void _forceReloadContent() {
    var folderName = _remoteFolder.name;

    if (_remoteFolder.isHome) {
      folderName = AppLocalizations.of(context)!.titleMyStorage;
    }

    setState(() {
      _futureLoadFolder =
          _resProvider.openFolder(_remoteFolder).then((content) {
        setState(() {
          _updateTitle(folderName, content: content);
          _updateDrawer(_remoteFolder.isHome);
        });
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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: MyStorageAppBar(
        titleText: _title,
        onAdvancedActionPressed: _popupActionHandler,
        selectModeEnable: selectModeEnable,
        onDelete: () => _deleteRemoteResource(_folderContent.selectedResources),
        onToggleCheckAll: _toggleCheckAll,
        onDownload: () async {
          await _askSaveFile(_folderContent.selectedResources);
          setState(() {
            _toggleSelectMode();
          });
        },
      ),
      drawer: _canShowDrawer
          ? const AppNavigator(currentRoute: MyStoragePage.routeName)
          : null,
      body: RefreshIndicator(
        onRefresh: () {
          _forceReloadContent();
          return _futureLoadFolder;
        },
        child: FutureBuilder(
          future: _futureLoadFolder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var loadedContent = snapshot.data as FolderContent?;

              if (loadedContent == null) {
                return const FailLoadContent();
              }

              _folderContent = loadedContent;

              if (_folderContent.isEmpty) {
                return EmptyContent();
              }

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
                    _askSaveFile([file]);
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
