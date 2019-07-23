/**
 *  author : archer
 *  date : 2019-06-18 11:24
 *  description :
 */

import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  static final String routeName = "my";
  final String userName;
  MyPage({this.userName, Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("My"),
      ),
    );
  }
}
