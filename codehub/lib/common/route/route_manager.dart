/**
 *  author : archer
 *  date : 2019-06-19 21:56
 *  description : 路由管理, 所有页面的路由控制
 */

import 'package:flutter/material.dart';

class RouteManager {

  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

}