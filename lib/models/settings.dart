class Settings {
  final String host;
  final String defaultFolderDownload;
  final bool openFileUponDownload;

  const Settings({
    this.host = '',
    this.defaultFolderDownload = '',
    this.openFileUponDownload = true,
  });

  Settings copyWith({
    String? host,
    String? defaultFolderDownload,
    bool? openFileUponDownload,
  }) {
    return Settings(
      host: host ?? this.host,
      defaultFolderDownload:
          defaultFolderDownload ?? this.defaultFolderDownload,
      openFileUponDownload: openFileUponDownload ?? this.openFileUponDownload,
    );
  }
}
