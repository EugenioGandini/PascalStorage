import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:filebrowser/models/models.dart';

class FolderWidget extends StatelessWidget {
  final RemoteFolder folder;
  final VoidCallback? onTap;

  const FolderWidget({
    super.key,
    required this.folder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: const Icon(Icons.folder),
          title: Text(folder.name),
          subtitle: Text(DateFormat.yMMMd().add_jm().format(folder.modified)),
        ),
      ),
    );
  }
}
