/**
 *  author : archer
 *  date : 2019-06-30 20:42
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/constant/global_style.dart';

class CardItem extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final Color color;
  final RoundedRectangleBorder shape;
  final double elevation;

  CardItem({@required this.child,this.margin,this.color,this.shape, this.elevation = 5.0});

  @override
  Widget build(BuildContext context) {
    EdgeInsets margin = this.margin;
    RoundedRectangleBorder shape = this.shape;
    Color color = this.color;
    margin ?? EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0,bottom: 10.0);
    shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)));
    color ?? CustomColors.cardWhite;
    return Card(
      margin: margin,
      shape: shape,
      color: color,
      child: child,
    );
  }
}
