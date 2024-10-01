import 'package:filebrowser/models/models.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileDetails extends StatelessWidget {
  final void Function(String) onSaveFile;
  final RemoteFile file;

  const FileDetails({
    super.key,
    required this.file,
    required this.onSaveFile,
  });

  void _selectFolder() async {
    var result = await FilePicker.platform.getDirectoryPath();

    if (result == null) return;

    String directoryPath = result;

    onSaveFile(directoryPath);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _selectFolder,
          child: Text('Salva in...'),
        )
      ],
    );
  }
}
