import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../models/models.dart';

import 'share_item.dart';

class ListShare extends StatelessWidget {
  final List<Share> shares;
  final Function(Share) onTap;

  final double maxWidthItem = 430;

  const ListShare({
    super.key,
    required this.shares,
    required this.onTap,
  });

  Widget _buildAnimatedStaggeredChild(
      int indexElement, int columnUsed, Widget child) {
    return AnimationConfiguration.staggeredGrid(
      duration: const Duration(milliseconds: 750),
      position: indexElement,
      columnCount: columnUsed,
      child: FadeInAnimation(
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // print(width);

    var maxCrossAxisExtent = maxWidthItem;

    var columns = (width / maxCrossAxisExtent).ceil();
    var aspectRatio = (width / 90.21) / columns;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: AnimationLimiter(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxCrossAxisExtent,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: const EdgeInsets.only(top: 8, bottom: 96, left: 8, right: 8),
          itemBuilder: (context, index) {
            var share = shares[index];

            Widget elementGrid = ShareItem(
              share: share,
              onTap: () => onTap(share),
            );

            return _buildAnimatedStaggeredChild(index, columns, elementGrid);
          },
          itemCount: shares.length,
        ),
      ),
    );
  }
}
