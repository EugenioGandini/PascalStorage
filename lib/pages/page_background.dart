import 'package:flutter/material.dart';

import '../widgets/footer.dart';
import '../config/colors.dart';

class PageBackground extends StatelessWidget {
  final Widget child;

  const PageBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomCenter,
            child: Footer(),
          ),
          child,
        ],
      ),
    );
  }
}
