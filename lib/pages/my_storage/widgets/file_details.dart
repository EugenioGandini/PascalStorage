import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';

import '../../../utils/platform.dart';
import '../../../utils/files_utils.dart';
import '../../../utils/storage_utils.dart';

/// Widget for displaying a single file details with
/// actions:
/// - save locally
/// - delete remotly
/// - move remotly
/// - rename remotly
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
    String? directoryPath = await chooseOutputFolder();

    if (directoryPath == null) return;

    onSaveFile(directoryPath);
  }

  void _saveDownloadFolder() async {
    String? outputPath = await getDownloadFolder();

    if (outputPath == null) return;

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
