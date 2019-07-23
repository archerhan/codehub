/**
 *  author : archer
 *  date : 2019-06-26 12:36
 *  description :
 */

import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  final String image;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  UserIcon(
      {this.image,
      this.onPressed,
      this.width = 30.0,
      this.height = 30.0,
      this.padding})
      : super();

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding:
          padding ?? const EdgeInsets.only(top: 4.0, right: 5.0, left: 5.0),
      constraints: const BoxConstraints(minHeight: 0.0, minWidth: 0.0),
      child: ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: "resource/images/snow_sun.jpg",
          image: image,
          fit: BoxFit.fitWidth,
          width: width,
          height: height,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
