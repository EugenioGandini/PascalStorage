import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:filebrowser/providers/auth_provider.dart';
import 'package:filebrowser/providers/resource_provider.dart';

import 'package:filebrowser/pages/pages.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => AuthProvider()),
      ChangeNotifierProxyProvider<AuthProvider, ResourceProvider>(
          create: (ctx) => ResourceProvider(),
          update: (ctx, authProvider, resProvider) {
            if (resProvider == null) return ResourceProvider();

            if (authProvider.isLoggedIn) {
              resProvider.updateToken(authProvider.token!);
            }

            return resProvider;
          }),
    ],
    child: const FileBrowserApp(),
  ));
}

class FileBrowserApp extends StatelessWidget {
  const FileBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Browser Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        MyStoragePage.routeName: (context) => const MyStoragePage(),
      },
      initialRoute: LoginPage.routeName,
    );
  }
}
