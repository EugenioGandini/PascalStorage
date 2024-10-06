import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData getAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBlue2,
      foregroundColor: Colors.black,
      elevation: 12,
      scrolledUnderElevation: 24,
      shadowColor: Colors.black,
    ),
  );
}
