import 'dart:math';
import 'package:flutter/material.dart';

import '../../page_background.dart';

/// Base layout of all pages (except login)
/// with a stack of:
/// - gradient background
/// - floating action button for opening other actions
class ScaffoldPage extends StatefulWidget {
  final Widget body;
  final AppBar? appBar;
  final Widget? drawer;

  final VoidCallback selectFileToBeUploaded;
  final VoidCallback crateNewResource;
  final VoidCallback toggleSelectMode;

  const ScaffoldPage({
    super.key,
    required this.body,
    required this.selectFileToBeUploaded,
    required this.crateNewResource,
    required this.toggleSelectMode,
    this.appBar,
    this.drawer,
  });

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  bool _showFullMenu = false;
  double _rotationIcon = 180;
  double _rotationIconEnd = 180;

  Widget _buildMainMenuButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FloatingActionButton(
        heroTag: 'MenuController',
        onPressed: _toggleShowFullMenu,
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
      ),
    );
  }

  void _toggleShowFullMenu() {
    setState(() {
      _showFullMenu = !_showFullMenu;
      _rotationIconEnd = _rotationIconEnd + (_showFullMenu ? -180 : 180);
    });
  }

  List<Widget> _buildOptionsMenu() {
    return [
      FloatingActionButton(
        heroTag: 'MultiSelect',
        onPressed: () {
          _toggleShowFullMenu();
          widget.toggleSelectMode();
        },
        child: const Icon(Icons.select_all),
      ),
      FloatingActionButton(
        heroTag: 'CreateNewFolder',
        onPressed: () {
          _toggleShowFullMenu();
          widget.crateNewResource();
        },
        child: const Icon(Icons.create_new_folder),
      ),
      FloatingActionButton(
        heroTag: 'UploadNewFile',
        onPressed: () {
          _toggleShowFullMenu();
          widget.selectFileToBeUploaded();
        },
        child: const Icon(Icons.upload),
      ),
    ].map((singleOption) {
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
      drawer: widget.drawer,
      body: Stack(
        children: [
          PageBackground(
            child: widget.body,
          ),
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
