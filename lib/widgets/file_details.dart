import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/settings_provider.dart';

import '../utils/platform.dart';
import '../utils/files_utils.dart';
import '../utils/storage_utils.dart';

/// Widget for displaying a single file details with
/// actions:
/// - save locally
/// - delete remotly
/// - move remotly
/// - rename remotly
class FileDetails extends StatelessWidget {
  final String fileName;
  final String fileExtension;
  final DateTime? fileModified;
  final int? fileSize;
  final int activeShares;

  final void Function(String)? onSaveFile;
  final VoidCallback? onDelete;
  final VoidCallback? onMove;
  final VoidCallback? onRename;
  final VoidCallback? toggleSync;
  final VoidCallback? onShare;
  final VoidCallback? onRemoveShare;
  final bool isSynchronized;

  const FileDetails({
    super.key,
    required this.fileName,
    this.fileExtension = '',
    this.fileSize,
    this.fileModified,
    this.onSaveFile,
    this.onDelete,
    this.onMove,
    this.onRename,
    this.toggleSync,
    this.onShare,
    this.onRemoveShare,
    this.isSynchronized = false,
    this.activeShares = 0,
  });

  void _selectFolder() async {
    String? directoryPath = await chooseOutputFolder();

    if (directoryPath == null) return;

    onSaveFile!(directoryPath);
  }

  void _saveDownloadFolder(BuildContext context) async {
    String? outputPath;

    if (!Platform.isWeb) {
      var customDestination =
          Provider.of<SettingsProvider>(context, listen: false)
              .settings
              .defaultFolderDownload;

      if (customDestination.isNotEmpty) {
        outputPath = customDestination;
      }
    }

    outputPath ??= await getDownloadFolder();

    if (outputPath == null) return;

    onSaveFile!(outputPath);
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
    return const SizedBox(width: 16);
  }

  @override
  Widget build(BuildContext context) {
    var subtitle = '';

    if (fileModified != null) {
      subtitle += DateFormat.yMMMd().add_jm().format(fileModified!.toLocal());
    }
    if (fileSize != null) {
      subtitle += " (${getFileSize(fileSize!)})";
    }

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(subtitle),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: getFileBackgroundColor(fileExtension),
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  getFileIcon(fileExtension),
                  size: 42,
                  color: getFileForegroundColor(fileExtension),
                ),
              ),
            ],
          ),
          if (onSaveFile != null)
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
                  onPressed: () => _saveDownloadFolder(context),
                  child: Text(AppLocalizations.of(context)!.download),
                ),
              ],
            ),
          if (onRename != null)
            ..._buildSubArea(
              context,
              AppLocalizations.of(context)!.modifyTitle,
              [
                // ElevatedButton(
                //   onPressed: () => onMove(file),
                //   child: Text(AppLocalizations.of(context)!.moveTo),
                // ),
                // _buildSeparatorAction(),
                ElevatedButton(
                  onPressed: () => onRename!(),
                  child: Text(AppLocalizations.of(context)!.renameInto),
                ),
              ],
            ),
          if (onShare != null && onRemoveShare != null)
            ..._buildSubArea(
              context,
              AppLocalizations.of(context)!.shareTitle,
              [
                ElevatedButton(
                  onPressed: () => onShare!(),
                  child: Text(AppLocalizations.of(context)!.share),
                ),
                if (activeShares > 0) ...[
                  _buildSeparatorAction(),
                  ElevatedButton(
                    onPressed: () => onRemoveShare!(),
                    child: Text(AppLocalizations.of(context)!
                        .removeShare(activeShares)),
                  ),
                ]
              ],
            ),
          if (onDelete != null)
            ..._buildSubArea(
              context,
              AppLocalizations.of(context)!.deleteTitle,
              [
                ElevatedButton(
                  onPressed: () => onDelete!(),
                  child: Text(AppLocalizations.of(context)!.delete),
                ),
              ],
            ),
          if (toggleSync != null)
            ..._buildSubArea(
              context,
              AppLocalizations.of(context)!.syncTitle,
              [
                ElevatedButton(
                  onPressed: () => toggleSync!(),
                  child: Text(
                    !isSynchronized
                        ? AppLocalizations.of(context)!.syncActivate
                        : AppLocalizations.of(context)!.syncDeactivate,
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
