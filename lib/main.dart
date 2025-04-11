import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'initializer.dart';

import 'models/models.dart';

import 'providers/settings_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/resource_provider.dart';

import 'pages/pages.dart';

import 'config/theme.dart';

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
              resProvider.updateLogin(authProvider.token!);
            } else {
              resProvider.removeLogout();
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
      title: 'Pascal Storage',
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
        SettingsPage.routeName: (context) => const SettingsPage(),
        OfflinePage.routeName: (context) => const OfflinePage(),
        SharePage.routeName: (context) => const SharePage(),
      },
      initialRoute: LoginPage.routeName,
    );
  }
}
