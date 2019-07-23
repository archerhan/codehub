/**
 *  author : archer
 *  date : 2019-06-27 11:43
 *  description :
 */

import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    this.color,
    this.fabLocation,
    this.shape,
    this.rowContents,
  });

  final Color color;
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape shape;
  final List<Widget> rowContents;

  static final List<FloatingActionButtonLocation> kCenterLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: color,
      child: Row(children: rowContents),
      shape: shape,
    );
  }
}
