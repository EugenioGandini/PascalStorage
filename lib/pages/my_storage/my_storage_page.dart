import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'file_operations.dart';
import 'folder_operations.dart';
import 'general_operations.dart';

import '../../models/models.dart';
import '../../utils/utilities.dart';
import '../../providers/settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resource_provider.dart';
import '../login/login_page.dart';
import '../base_page.dart';

import '../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class MyStoragePage extends StatefulWidget {
  static const String routeName = '/myStorage';

  const MyStoragePage({super.key});

  @override
  State<MyStoragePage> createState() => _MyStoragePageState();
}

class _MyStoragePageState extends State<MyStoragePage> {
  final Logger _logger = const Logger('MyStoragePage');

  late FileOperations _fileOperations;
  late FolderOperations _folderOperations;
  late GeneralOperations _generalOperations;

  late Future _futureLoadFolder;
  late ResourceProvider _resProvider;
  late ResourceFolder _remoteFolder;
  bool selectModeEnable = false;
  bool _init = false;
  bool _canShowDrawer = false;
  bool _draggingExternal = false;
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
      _remoteFolder = arguments as ResourceFolder;

      _updateTitle(_remoteFolder);

      _futureLoadFolder =
          _resProvider.openFolder(_remoteFolder).then((loadedFolder) {
        setState(() {
          _updateTitle(loadedFolder);
          _updateDrawer(_remoteFolder.isHome);
        });

        return loadedFolder;
      });

      _logger.message('Loading folder ${_remoteFolder.name}');
    } else {
      _remoteFolder = _resProvider.homeFolder;
      _updateTitle(_remoteFolder);

      _futureLoadFolder = _resProvider.loadHomeFolder().then((loadedFolder) {
        setState(() {
          _updateTitle(loadedFolder);
          _updateDrawer(_remoteFolder.isHome);
        });

        return loadedFolder;
      });

      _logger.message('Loading HOME folder');
    }

    _fileOperations = FileOperations(
      context: context,
      resProvider: _resProvider,
      logger: _logger,
      onReloadContentNeeded: _forceReloadContent,
    );

    _folderOperations = FolderOperations(
      context: context,
      resProvider: _resProvider,
      logger: _logger,
      onReloadContentNeeded: _forceReloadContent,
    );

    _generalOperations = GeneralOperations(
      context: context,
      resProvider: _resProvider,
      logger: _logger,
      onReloadContentNeeded: _forceReloadContent,
    );

    _init = true;
  }

  void _updateTitle(ResourceFolder? folder) {
    if (folder == null) return;

    String title = folder.isHome
        ? AppLocalizations.of(context)!.titleMyStorage
        : folder.name;

    if (folder.size != 0) {
      title = "$title (${getHumanReadableSize(folder.size)})";
    }

    _title = title;
  }

  void _updateDrawer(bool isHomeFolder) {
    _canShowDrawer = isHomeFolder;
  }

  void _openFolder(BuildContext context, ResourceFolder folder) {
    _logger.message('User navigate to folder ${folder.name}');

    Navigator.of(context).pushNamed(MyStoragePage.routeName, arguments: folder);
  }

  void _openFileDetails(BuildContext context, ResourceFile file) {
    _logger.message('User opened file ${file.name}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: FileDetails(
              fileName: file.name,
              fileExtension: file.extension,
              fileModified: file.modified,
              fileSize: file.size,
              onSaveFile: (dir) async {
                Navigator.of(context).pop();

                await _fileOperations.saveFile([file], dir);

                if (!_settings.openFileUponDownload) return;

                OpenFile.open(path.join(dir, file.name));
              },
              onMove: () => {}, //_selectNewFolderFile(file),
              onRename: () => _generalOperations.selectNewName(file),
              onDelete: () {
                Navigator.of(context).pop();
                _generalOperations.deleteRemoteResource([file]);
              },
            ),
          ),
        );
      },
    );
  }

  void _openFolderDetails(BuildContext context, ResourceFolder folder) {
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
              onRename: (folder) => _generalOperations.selectNewName(folder),
              onDelete: (folder) {
                Navigator.of(context).pop();
                _generalOperations.deleteRemoteResource([folder]);
              },
            ),
          ),
        );
      },
    );
  }

  void _updateExternalDragging(bool draggingIn) {
    setState(() {
      _draggingExternal = draggingIn;
    });
  }

  /////// Actions ///////

  void _forceReloadContent() {
    setState(() {
      _futureLoadFolder =
          _resProvider.openFolder(_remoteFolder).then((loadedFolder) {
        setState(() {
          _updateTitle(loadedFolder);
          _updateDrawer(_remoteFolder.isHome);
        });

        return loadedFolder;
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
      _remoteFolder.toggleSelectMode();
      selectModeEnable = _remoteFolder.isSelectModeActive;
    });
  }

  void _toggleResourceSelection(ResourceFile fileSelected) {
    var updatedFile = fileSelected.copyWith(selected: !fileSelected.selected);

    setState(() {
      _remoteFolder.replaceFile(updatedFile);
    });
  }

  void _toggleFolderSelection(ResourceFolder folderSelected) {
    var updatedFolder =
        folderSelected.copyWith(selected: !folderSelected.selected);

    setState(() {
      _remoteFolder.replaceFolder(updatedFolder);
    });
  }

  void _toggleCheckAll() {
    setState(() {
      _remoteFolder.toggleSelectAllResources();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: MyStorageAppBar(
        titleText: _title,
        onAdvancedActionPressed: _popupActionHandler,
        selectModeEnable: selectModeEnable,
        onDelete: () => _generalOperations
            .deleteRemoteResource(_remoteFolder.selectedResources),
        onToggleCheckAll: _toggleCheckAll,
        onDownload: () async {
          await _fileOperations.askSaveFile(
              _remoteFolder.selectedResources, _settings);
          setState(() {
            _toggleSelectMode();
          });
        },
      ),
      drawer: _canShowDrawer
          ? const AppNavigator(currentRoute: MyStoragePage.routeName)
          : null,
      body: DropTarget(
        onDragDone: (details) =>
            _fileOperations.draggedFiles(details.files, _remoteFolder),
        onDragEntered: (_) => _updateExternalDragging(true),
        onDragExited: (_) => _updateExternalDragging(false),
        enable: ModalRoute.of(context)!.isCurrent,
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () {
                _forceReloadContent();
                return _futureLoadFolder;
              },
              child: FutureBuilder(
                future: _futureLoadFolder,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var loadedContent = snapshot.data as ResourceFolder?;

                    if (loadedContent == null) {
                      return const FailLoadContent();
                    }

                    _remoteFolder = loadedContent;

                    if (_remoteFolder.isEmpty) {
                      return const EmptyContent();
                    }

                    return FolderContentWidget(
                      folder: _remoteFolder,
                      onFileTap: (file) {
                        if (selectModeEnable) {
                          _toggleResourceSelection(file);
                        } else {
                          _fileOperations.askSaveFile([file], _settings);
                        }
                      },
                      onFolderTap: (folder) {
                        if (selectModeEnable) {
                          _toggleFolderSelection(folder);
                        } else {
                          _openFolder(context, folder);
                        }
                      },
                      onFileLongPress: (file) =>
                          _openFileDetails(context, file),
                      onFolderLongPress: (folder) =>
                          _openFolderDetails(context, folder),
                      onResourceMoved: _generalOperations.moveResource,
                      selectModeEnable: selectModeEnable,
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            if (_draggingExternal) const DraggingExternalResources()
          ],
        ),
      ),
      selectFileToBeUploaded: () =>
          _fileOperations.selectFileToBeUploaded(_remoteFolder),
      crateNewResource: () => _folderOperations.crateNewResource(_remoteFolder),
      toggleSelectMode: _toggleSelectMode,
    );
  }
}
