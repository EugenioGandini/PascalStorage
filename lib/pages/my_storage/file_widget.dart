import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:filebrowser/models/models.dart';

class FileWidget extends StatelessWidget {
  final File file;
  final VoidCallback? onTap;

  const FileWidget({
    super.key,
    required this.file,
    this.onTap,
  });

  IconData get icon {
    switch (file.extension) {
      case 'sql':
      case 'txt':
      case 'log':
        return Icons.text_format;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'tar':
      case 'gz':
      case '7zip':
      case 'zip':
        return Icons.folder_zip_outlined;
      case 'jpg':
      case 'png':
        return Icons.image;
      case 'mp4':
      case 'mkv':
      case 'avi':
      case 'mov':
        return Icons.movie;
      default:
        return Icons.file_open;
    }
  }

  Color get backgroundColor {
    switch (file.extension) {
      case 'sql':
      case 'txt':
      case 'log':
        return Colors.grey.withOpacity(0.5);
      case 'pdf':
        return Colors.red.withOpacity(0.8);
      case 'tar':
      case 'gz':
      case '7zip':
      case 'zip':
        return Colors.yellow.withOpacity(0.8);
      case 'jpg':
      case 'png':
        return Colors.green.withOpacity(0.7);
      case 'mp4':
      case 'mkv':
      case 'avi':
      case 'mov':
        return Colors.blue.withOpacity(0.7);
      default:
        return Colors.white;
    }
  }

  Color get foregroundColor {
    switch (file.extension) {
      case 'sql':
      case 'txt':
      case 'log':
        return Colors.black;
      case 'pdf':
        return Colors.white;
      case 'tar':
      case 'gz':
      case '7zip':
      case 'zip':
        return Colors.black;
      case 'png':
        return Colors.black;
      case 'mp4':
      case 'mkv':
      case 'avi':
      case 'mov':
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  String get name {
    if (file.name.length < 15) return file.name;

    return '${file.name.substring(0, 12)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foregroundColor),
              Text(
                name,
                style: TextStyle(
                  color: foregroundColor,
                ),
              ),
              Text(
                DateFormat.jm().format(file.modified),
                style: TextStyle(
                  fontSize: 12,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
