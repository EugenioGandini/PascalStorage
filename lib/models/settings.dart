class Settings {
  final String host;

  const Settings({
    this.host = '',
  });

  Settings copyWith({String host = ''}) {
    return Settings(host: host);
  }
}
