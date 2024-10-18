import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/models.dart';
import '../../utils/platform.dart';
import '../../config/permissions.dart';
import '../../utils/files_utils.dart';

class FileDetails extends StatelessWidget {
  final void Function(String) onSaveFile;
  final void Function(RemoteFile) onDelete;
  final void Function(RemoteFile) onMove;
  final void Function(RemoteFile) onRename;
  final RemoteFile file;

  const FileDetails({
    super.key,
    required this.file,
    required this.onSaveFile,
    required this.onDelete,
    required this.onMove,
    required this.onRename,
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

    var outputPath = "";

    if (!Platform.isWeb) {
      var downloadDirectory = await getDownloadsDirectory();

      if (downloadDirectory == null) return;
      outputPath = downloadDirectory.path;
    }

    onSaveFile(outputPath);
  }

  List<Widget> _buildSubArea(
      BuildContext context, String title, List<Widget> children) {
    return [
      const Divider(),
      Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(
        height: 8,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    ];
  }

  Widget _buildSeparatorAction() {
    return const SizedBox(
      width: 16,
    );
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
          ..._buildSubArea(
            context,
            AppLocalizations.of(context)!.downloadTitle,
            [
              if (!Platform.isWeb) ...[
                ElevatedButton(
                  onPressed: _selectFolder,
                  child: Text(AppLocalizations.of(context)!.saveTo),
                ),
                _buildSeparatorAction(),
              ],
              ElevatedButton(
                onPressed: _saveDownloadFolder,
                child: Text(AppLocalizations.of(context)!.download),
              ),
            ],
          ),
          ..._buildSubArea(
            context,
            AppLocalizations.of(context)!.modifyTitle,
            [
              ElevatedButton(
                onPressed: () => onMove(file),
                child: Text(AppLocalizations.of(context)!.moveTo),
              ),
              _buildSeparatorAction(),
              ElevatedButton(
                onPressed: () => onRename(file),
                child: Text(AppLocalizations.of(context)!.renameInto),
              ),
            ],
          ),
          ..._buildSubArea(
            context,
            AppLocalizations.of(context)!.deleteTitle,
            [
              ElevatedButton(
                onPressed: () => onDelete(file),
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
