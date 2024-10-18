import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart';

class FolderWidget extends StatelessWidget {
  final RemoteFolder folder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const FolderWidget({
    super.key,
    required this.folder,
    this.onTap,
    this.onLongPress,
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
        onLongPress: onLongPress,
        child: ListTile(
          leading: const Icon(Icons.folder),
          title: Text(folder.name),
          subtitle: Text(
              DateFormat.yMMMd().add_jm().format(folder.modified.toLocal())),
        ),
      ),
    );
  }
}
