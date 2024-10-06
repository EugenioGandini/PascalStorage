import 'package:flutter/material.dart';

import '../models/remote_file.dart';

IconData getFileIcon(RemoteFile file) {
  switch (file.extension) {
    case 'sql':
    case 'txt':
    case 'log':
    case 'docx':
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
    case 'xlsx':
      return Icons.table_chart_sharp;
    case 'html':
      return Icons.html;
    default:
      return Icons.file_open;
  }
}

Color getFileBackgroundColor(RemoteFile file) {
  switch (file.extension) {
    case 'sql':
    case 'txt':
    case 'log':
      return Colors.grey;
    case 'pdf':
      return Colors.red.withOpacity(0.8);
    case 'tar':
    case 'gz':
    case '7zip':
    case 'zip':
      return Colors.yellow.withOpacity(0.8);
    case 'jpg':
    case 'png':
    case 'xlsx':
      return const Color.fromARGB(255, 65, 231, 70).withOpacity(0.7);
    case 'mp4':
    case 'mkv':
    case 'avi':
    case 'mov':
    case 'docx':
      return Colors.blue.withOpacity(0.7);
    default:
      return const Color.fromARGB(255, 204, 204, 204);
  }
}

Color getFileForegroundColor(RemoteFile file) {
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
    case 'jpg':
    case 'png':
    case 'xlsx':
      return Colors.black;
    case 'mp4':
    case 'mkv':
    case 'avi':
    case 'mov':
    case 'docx':
      return Colors.white;
    default:
      return Colors.black;
  }
}

String getFileSize(RemoteFile file) {
  if (file.size < 1000000) {
    return "~ ${(file.size / 1000).round()} Kb"; // in Kb
  }
  if (file.size < 1000000000) {
    return "~ ${(file.size / 1000000).round()} Mb"; // in Mb
  }
  return "~ ${(file.size / 1000000000).round()} Gb"; // in Gb
}
