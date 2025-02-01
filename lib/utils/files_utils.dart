import 'package:flutter/material.dart';

IconData getFileIcon(String extension) {
  switch (extension.toLowerCase()) {
    case 'sql':
    case 'txt':
    case 'log':
    case 'odt':
    case 'docx':
    case 'rtf':
      return Icons.text_format;
    case 'pptx':
      return Icons.present_to_all;
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
    case 'js':
    case 'json':
      return Icons.javascript;
    case 'css':
      return Icons.css;
    case 'apk':
      return Icons.android;
    case 'exe':
      return Icons.settings_applications_sharp;
    case 'dart':
      return Icons.code;
    default:
      return Icons.file_open;
  }
}

Color getFileBackgroundColor(String extension) {
  switch (extension.toLowerCase()) {
    case 'sql':
    case 'txt':
    case 'log':
      return Colors.grey;
    case 'pptx':
      return const Color.fromARGB(255, 252, 119, 66);
    case 'pdf':
      return const Color.fromARGB(255, 252, 79, 66);
    case 'tar':
    case 'gz':
    case '7zip':
    case 'zip':
    case 'js':
    case 'json':
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
    case 'dart':
      return const Color.fromARGB(255, 18, 121, 206);
    case 'css':
      return Colors.blue;
    case 'apk':
    case 'exe':
      return Colors.lime;
    default:
      return const Color.fromARGB(255, 204, 204, 204);
  }
}

Color getFileForegroundColor(String extension) {
  switch (extension.toLowerCase()) {
    case 'sql':
    case 'txt':
    case 'log':
    case 'pptx':
    case 'tar':
    case 'gz':
    case '7zip':
    case 'zip':
    case 'js':
    case 'json':
    case 'css':
    case 'jpg':
    case 'png':
    case 'xlsx':
    case 'apk':
    case 'exe':
      return Colors.black;
    case 'pdf':
    case 'mp4':
    case 'mkv':
    case 'avi':
    case 'mov':
    case 'odt':
    case 'docx':
    case 'dart':
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

String getFileSize(int size) {
  return getHumanReadableSize(size);
}
