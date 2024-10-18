import 'dart:math';
import 'package:flutter/material.dart';

import '../config/colors.dart';

class BasePage extends StatefulWidget {
  final Widget body;
  final AppBar? appBar;
  final List<FloatingActionButton> floatingActionButton;

  const BasePage({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton = const [],
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool _showFullMenu = false;
  double _rotationIcon = 180;
  double _rotationIconEnd = 180;

  bool get isActionMenuVisible {
    return widget.floatingActionButton.isNotEmpty;
  }

  Widget _buildMainMenuButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FloatingActionButton(
        heroTag: 'MenuController',
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 100),
          tween: Tween(begin: _rotationIcon, end: _rotationIconEnd),
          builder: (ctx, value, _) {
            return Transform.rotate(
              angle: value * pi / 180,
              child: const Icon(
                Icons.expand_circle_down,
                size: 40,
                color: Colors.black87,
              ),
            );
          },
          onEnd: () {
            setState(() {
              _rotationIcon = _rotationIconEnd;
            });
          },
        ),
        onPressed: () {
          setState(() {
            _showFullMenu = !_showFullMenu;
            _rotationIconEnd = _rotationIconEnd + (_showFullMenu ? -180 : 180);
          });
        },
      ),
    );
  }

  List<Widget> _buildOptionsMenu() {
    return widget.floatingActionButton.map((singleOption) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: singleOption,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Stack(
        children: [
          Container(
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
            child: widget.body,
          ),
          if (isActionMenuVisible)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showFullMenu) ..._buildOptionsMenu(),
                    _buildMainMenuButton(context),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
