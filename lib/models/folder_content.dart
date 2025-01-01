import './models.dart';

class FolderContent {
  String path = "";

  RemoteFolder currentFolder;
  List<RemoteFolder> folders = [];
  List<RemoteFile> files = [];

  bool _selectModeEnable = false;
  bool _allSelected = false;

  FolderContent({
    required this.currentFolder,
  });

  bool containsFileWithName(String fileName) {
    return files.any((file) => file.name == fileName);
  }

  bool get isEmpty {
    return files.isEmpty && folders.isEmpty;
  }

  int get folderSize {
    if (files.isEmpty) return 0;

    return files.map((file) => file.size).reduce((accumulator, sizeFolder) {
      return accumulator + sizeFolder;
    });
  }

  bool get isSelectModeActive {
    return _selectModeEnable;
  }

  List<Resource> get selectedResources {
    var selectedFiles = files.where((file) => file.selected).toList();
    var selectedFolders = folders.where((folder) => folder.selected).toList();

    return [...selectedFiles, ...selectedFolders];
  }

  void toggleSelectMode() {
    if (_selectModeEnable) {
      folders = folders.map((folder) {
        if (!folder.selected) return folder;

        return folder.copyWith(selected: false);
      }).toList();

      files = files.map((file) {
        if (!file.selected) return file;

        return file.copyWith(selected: false);
      }).toList();
    }

    _selectModeEnable = !_selectModeEnable;
  }

  void toggleSelectAllResources() {
    if (_allSelected) {
      _allSelected = false;
    } else {
      _allSelected = true;
    }

    folders = folders.map((folder) {
      return folder.copyWith(selected: _allSelected);
    }).toList();

    files = files.map((file) {
      return file.copyWith(selected: _allSelected);
    }).toList();
  }

  void replaceFile(RemoteFile updatedFile) {
    var indexOldFile = files.indexWhere((file) => file == updatedFile);

    if (indexOldFile < 0) return;

    files.removeAt(indexOldFile);
    files.insert(indexOldFile, updatedFile);
  }

  void replaceFolder(RemoteFolder updatedFolder) {
    var indexOldFolder =
        folders.indexWhere((folder) => folder == updatedFolder);

    if (indexOldFolder < 0) return;

    folders.removeAt(indexOldFolder);
    folders.insert(indexOldFolder, updatedFolder);
  }
}
