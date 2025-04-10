import 'dart:math';
import 'package:flutter/material.dart';

import '../my_storage_page.dart';
import './my_storage_app_bar.dart';

import '../../../widgets/app_navigator.dart';
import '../../page_background.dart';

/// Base layout of all pages (except login)
/// with a stack of:
/// - gradient background
/// - floating action button for opening other actions
class ScaffoldPage extends StatefulWidget {
  /// The body of the scaffold of the my storage page.
  final Widget body;

  /// Tell if the drawer must be visible or not
  final bool showDrawer;

  /// Tell if the user has activated multi select mode
  final bool selectModeEnable;

  ///
  final VoidCallback selectFileToBeUploaded;

  /// Callback invoked when the user asks to create a new resource in the current folder.
  final VoidCallback crateNewResource;

  /// Callback invoked when the user toggle enable/disable resource selection mode.
  final VoidCallback toggleSelectMode;

  /// Callback invoked when the user select an advanced action from the appbar.
  final Function(String) onAdvancedActionPressed;

  /// Callback invoked when the user presses the delete button, in the appbar, for selected resources.
  final VoidCallback onDelete;

  /// Callback invoked when the user toggle check all resources.
  final VoidCallback onToggleCheckAll;

  /// Callback invoked when the user asks to download all selected resources.
  final VoidCallback onDownload;

  /// Callback invoked when the user filters the content by providing a keywork.
  final Function(String?) onFilterElements;

  /// The title of this page.
  final String titleText;

  const ScaffoldPage({
    super.key,
    required this.body,
    required this.titleText,
    required this.selectFileToBeUploaded,
    required this.crateNewResource,
    required this.toggleSelectMode,
    required this.onAdvancedActionPressed,
    required this.onDelete,
    required this.onToggleCheckAll,
    required this.onDownload,
    required this.onFilterElements,
    this.showDrawer = false,
    this.selectModeEnable = false,
  });

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> with RouteAware {
  bool _showFullMenu = false;
  double _rotationIcon = 180;
  double _rotationIconEnd = 180;
  bool _searchModeEnable = false;

  final FocusNode _focusNodeSearchInput = FocusNode();

  void _onSearch(bool enable) {
    setState(() {
      _searchModeEnable = enable;

      if (enable) {
        _focusNodeSearchInput.requestFocus();
      } else {
        widget.onFilterElements(null);
      }
    });
  }

  @override
  void didPopNext() {
    _onSearch(false);
  }

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
      appBar: MyStorageAppBar(
        context: context,
        focusNodeSearchInput: _focusNodeSearchInput,
        titleText: widget.titleText,
        onAdvancedActionPressed: widget.onAdvancedActionPressed,
        onDelete: widget.onDelete,
        onToggleCheckAll: widget.onToggleCheckAll,
        onDownload: widget.onDownload,
        onSearch: _onSearch,
        selectModeEnable: _searchModeEnable,
        onFilterElements: widget.onFilterElements,
        searchModeEnable: widget.selectModeEnable,
      ),
      drawer: widget.showDrawer
          ? const AppNavigator(currentRoute: MyStoragePage.routeName)
          : null,
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
