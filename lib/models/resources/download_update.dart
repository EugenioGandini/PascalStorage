import 'dart:typed_data';

class DownloadUpdate {
  int percentage;
  Uint8List? data;

  DownloadUpdate({
    this.percentage = 0,
    this.data,
  });
}
