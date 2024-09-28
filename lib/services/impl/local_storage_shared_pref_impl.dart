// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:filebrowser/models/settings.dart';

// import 'package:filebrowser/services/base/local_storage_service.dart';

// /// This implementation save the settings into
// /// local storage only
// class LocalStorageServiceSharedPrefImpl extends LocalStorageService {
//   @override
//   Future<Settings> loadSettings() async {
//     var preferences = SharedPreferencesAsync();

//     String? savedHost = await preferences.getString('host');

//     return Settings(
//       host: savedHost ?? '',
//     );
//   }

//   @override
//   Future<void> saveSettings(Settings settings) async {
//     var preferences = SharedPreferencesAsync();

//     await preferences.setString('host', settings.host);
//   }
// }
