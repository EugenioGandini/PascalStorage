import 'package:flutter/material.dart';

import '../models/remote_file.dart';

IconData getFileIcon(RemoteFile file) {
  switch (file.extension) {
    case 'sql':
    case 'txt':
    case 'log':
    case 'odt':
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
      return const Color.fromARGB(255, 252, 79, 66);
    case 'tar':
    case 'gz':
    case '7zip':
    case 'zip':
      return const Color.fromARGB(255, 241, 192, 57);
    case 'jpg':
    case 'png':
    case 'xlsx':
      return const Color.fromARGB(255, 56, 187, 61);
    case 'mp4':
    case 'mkv':
    case 'avi':
    case 'mov':
    case 'odt':
    case 'docx':
      return const Color.fromARGB(255, 18, 121, 206);
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
    case 'odt':
    case 'docx':
      return Colors.white;
    default:
      return Colors.black;
  }
}

String getHumanReadableSize(int sizeBytes) {
  if (sizeBytes < 1000000) {
    return "~ ${(sizeBytes / 1000).round()} Kb"; // in Kb
  }
  if (sizeBytes < 1000000000) {
    return "~ ${(sizeBytes / 1000000).round()} Mb"; // in Mb
  }
  return "~ ${(sizeBytes / 1000000000).round()} Gb"; // in Gb
}

String getFileSize(RemoteFile file) {
  return getHumanReadableSize(file.size);
}
