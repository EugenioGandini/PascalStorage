import 'package:filebrowser/models/models.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/permissions.dart';
import '../../utils/files_utils.dart';

class FileDetails extends StatelessWidget {
  final void Function(String) onSaveFile;
  final RemoteFile file;

  const FileDetails({
    super.key,
    required this.file,
    required this.onSaveFile,
  });

  void _selectFolder() async {
    if (!await hasStorageAccessPermission()) return;

    var result = await FilePicker.platform.getDirectoryPath();

    if (result == null) return;

    String directoryPath = result;

    onSaveFile(directoryPath);
  }

  void _saveDownloadFolder() async {
    if (!await hasStorageAccessPermission()) return;

    var downloadDirectory = await getDownloadsDirectory();

    if (downloadDirectory == null) return;

    onSaveFile(downloadDirectory.path);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  file.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: getFileBackgroundColor(file),
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  getFileIcon(file),
                  size: 42,
                  color: getFileForegroundColor(file),
                ),
              ),
            ],
          ),
          const Divider(),
          Text(
            AppLocalizations.of(context)!.downloadTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _selectFolder,
                child: Text(AppLocalizations.of(context)!.saveTo),
              ),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton(
                onPressed: _saveDownloadFolder,
                child: Text(AppLocalizations.of(context)!.download),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
