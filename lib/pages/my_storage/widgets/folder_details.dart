import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';

/// Widget for displaying a single folder details with
/// actions:
/// - delete remotly
/// - rename remotly
class FolderDetails extends StatelessWidget {
  // final void Function(String) onSaveFile;
  final void Function(RemoteFolder) onDelete;
  // final void Function(RemoteFile) onMove;
  final void Function(RemoteFolder) onRename;
  final RemoteFolder folder;

  const FolderDetails({
    super.key,
    required this.folder,
    // required this.onSaveFile,
    required this.onDelete,
    // required this.onMove,
    required this.onRename,
  });

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
                  folder.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromARGB(255, 204, 204, 204),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.folder,
                  size: 42,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          ..._buildSubArea(
            context,
            AppLocalizations.of(context)!.modifyTitle,
            [
              ElevatedButton(
                onPressed: () => onRename(folder),
                child: Text(AppLocalizations.of(context)!.renameInto),
              ),
            ],
          ),
          ..._buildSubArea(
            context,
            AppLocalizations.of(context)!.deleteTitle,
            [
              ElevatedButton(
                onPressed: () => onDelete(folder),
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
