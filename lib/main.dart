import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:filebrowser/initializer.dart';

import 'package:filebrowser/models/models.dart';

import 'package:filebrowser/providers/settings_provider.dart';
import 'package:filebrowser/providers/auth_provider.dart';
import 'package:filebrowser/providers/resource_provider.dart';

import 'package:filebrowser/pages/pages.dart';

import 'package:filebrowser/config/theme.dart';

Future<void> main() async {
  await Initializer.initialize();

  var settingsProvider = SettingsProvider();

  await settingsProvider.loadSavedSettings();

  Settings settings = settingsProvider.settings;

  var authProvider = AuthProvider(settings);

  await authProvider.loadSavedCredentials();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => settingsProvider),
        ChangeNotifierProxyProvider<SettingsProvider, AuthProvider>(
          create: (ctx) => authProvider,
          update: (ctx, settingsProvider, authProvider) {
            authProvider!.updateSettings(settingsProvider.settings);

            return authProvider;
          },
        ),
        ChangeNotifierProxyProvider2<SettingsProvider, AuthProvider,
            ResourceProvider>(
          create: (ctx) => ResourceProvider(settings),
          update: (ctx, settingsProvider, authProvider, resProvider) {
            resProvider!.updateSettings(settingsProvider.settings);

            if (authProvider.isLoggedIn) {
              resProvider.updateToken(authProvider.token!);
            } else {
              resProvider.removeToken();
            }

            return resProvider;
          },
        ),
      ],
      child: const FileBrowserApp(),
    ),
  );
}

class FileBrowserApp extends StatelessWidget {
  const FileBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Browser Flutter',
      theme: getAppTheme(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('it'),
      ],
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        MyStoragePage.routeName: (context) => const MyStoragePage(),
      },
      initialRoute: LoginPage.routeName,
    );
  }
}
