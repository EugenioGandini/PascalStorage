import 'package:flutter/material.dart';

import '../config/colors.dart';

class BasePage extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final FloatingActionButton? floatingActionButton;

  const BasePage({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.deepBlue,
              AppColors.blue,
              AppColors.blue,
              AppColors.lightBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
