/**
 *  author : archer
 *  date : 2019-06-29 21:01
 *  description :
 */
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverHeaderDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.snapConfig,
      this.child,
      this.builder,
      this.changeSize = false});

  final double minHeight;
  final double maxHeight;
  final Widget child;
  final Builder builder;
  final bool changeSize;
  final FloatingHeaderSnapConfiguration snapConfig;

  AnimationController animationController;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => math.min(minHeight, maxHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (builder != null) {
      return builder(context, shrinkOffset, overlapsContent);
    }
    return child;
  }

  @override
  bool shouldRebuild(SliverHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => snapConfig;
}

typedef Widget Builder(
    BuildContext context, double shrinkOffset, bool overlapsContent);
