import 'resource.dart';
import 'resource_file.dart';

class ResourceFolder extends Resource {
  List<ResourceFolder> _subfolders = [];
  List<ResourceFile> _files = [];
  String? _filterKeyword;

  bool _selectModeEnable = false;
  bool _allSelected = false;

  ResourceFolder({
    required super.path,
    required super.name,
    required super.size,
    required super.modified,
    super.selected,
  });

  List<ResourceFolder> get subfolders {
    if (_filterKeyword == null) return _subfolders;

    return _subfolders
        .where((file) =>
            file.name.toLowerCase().contains(_filterKeyword!.toLowerCase()))
        .toList();
  }

  List<ResourceFile> get files {
    if (_filterKeyword == null) return _files;

    return _files
        .where((file) =>
            file.name.toLowerCase().contains(_filterKeyword!.toLowerCase()))
        .toList();
  }

  ResourceFolder.home()
      : super(
          path: '',
          name: 'Home',
          size: 0,
          modified: DateTime.now(),
          selected: false,
        );

  static fromJson(Map<String, Object?> json) {
    return ResourceFolder(
      path: json['path'] as String,
      name: json['name'] as String,
      size: json['size'] as int,
      modified: DateTime.parse(json['modified'] as String),
    );
  }

  ResourceFolder copyWith({
    bool? selected,
  }) {
    return ResourceFolder(
      path: path,
      name: name,
      size: size,
      modified: modified,
      selected: selected ?? false,
    );
  }

  void addFiles(ResourceFile file) {
    _files.add(file);
  }

  void addSubfolder(ResourceFolder folder) {
    _subfolders.add(folder);
  }

  bool get isHome {
    return path == '/';
  }

  bool containsFileWithName(String fileName) {
    return files.any((file) => file.name == fileName);
  }

  ResourceFile? getFileWithName(String fileName) {
    var index = files.indexWhere((file) => file.name == fileName);
    if (index < 0) {
      return null;
    }
    return files[index];
  }

  bool get isEmpty {
    return files.isEmpty && subfolders.isEmpty;
  }

  @override
  int get size {
    if (files.isEmpty) return 0;

    return files.map((file) => file.size).reduce((accumulator, sizeFolder) {
      return accumulator + sizeFolder;
    });
  }

  void replaceFile(ResourceFile updatedFile) {
    var indexOldFile = files.indexWhere((file) => file == updatedFile);

    if (indexOldFile < 0) return;

    files.removeAt(indexOldFile);
    files.insert(indexOldFile, updatedFile);
  }

  void replaceFolder(ResourceFolder updatedFolder) {
    var indexOldFolder =
        subfolders.indexWhere((folder) => folder == updatedFolder);

    if (indexOldFolder < 0) return;

    subfolders.removeAt(indexOldFolder);
    subfolders.insert(indexOldFolder, updatedFolder);
  }

  bool get isSelectModeActive {
    return _selectModeEnable;
  }

  List<Resource> get selectedResources {
    var selectedFiles = files.where((file) => file.selected).toList();
    var selectedFolders =
        subfolders.where((folder) => folder.selected).toList();

    return [...selectedFiles, ...selectedFolders];
  }

  void toggleSelectMode() {
    if (_selectModeEnable) {
      _subfolders = _subfolders.map((folder) {
        if (!folder.selected) return folder;

        return folder.copyWith(selected: false);
      }).toList();

      _files = _files.map((file) {
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

    _subfolders = _subfolders.map((folder) {
      return folder.copyWith(selected: _allSelected);
    }).toList();

    _files = _files.map((file) {
      return file.copyWith(selected: _allSelected);
    }).toList();
  }

  void applyFilter(String? filter) {
    _filterKeyword = filter;
  }
}
