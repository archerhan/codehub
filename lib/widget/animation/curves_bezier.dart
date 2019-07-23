/**
 *  author : archer
 *  date : 2019-06-27 11:30
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
import 'package:bezier/bezier.dart';

class CurveBezier extends Curve {
  final quadraticCurve = new QuadraticBezier(
      [new Vector2(-4.0, 1.0), new Vector2(-2.0, -1.0), new Vector2(1.0, 1.0)]);

  @override
  double transformInternal(double t) {
    return quadraticCurve.pointAt(t).s;
  }
}
