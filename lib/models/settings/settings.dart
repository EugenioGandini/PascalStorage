class Settings {
  final String host;
  final String defaultFolderDownload;
  final bool openFileUponDownload;
  final Duration periodicSync;
  final bool syncAtLogin;
  final bool deleteOfflineResourceAtLogout;

  const Settings({
    this.host = '',
    this.defaultFolderDownload = '',
    this.openFileUponDownload = true,
    this.syncAtLogin = true,
    this.periodicSync = const Duration(minutes: 1),
    this.deleteOfflineResourceAtLogout = false,
  });

  Settings copyWith({
    String? host,
    String? defaultFolderDownload,
    bool? openFileUponDownload,
    bool? syncAtLogin,
    Duration? periodicSync,
    bool? deleteOfflineResourceAtLogout,
  }) {
    return Settings(
      host: host ?? this.host,
      defaultFolderDownload:
          defaultFolderDownload ?? this.defaultFolderDownload,
      openFileUponDownload: openFileUponDownload ?? this.openFileUponDownload,
      syncAtLogin: syncAtLogin ?? this.syncAtLogin,
      periodicSync: periodicSync ?? this.periodicSync,
      deleteOfflineResourceAtLogout:
          deleteOfflineResourceAtLogout ?? this.deleteOfflineResourceAtLogout,
    );
  }
}
