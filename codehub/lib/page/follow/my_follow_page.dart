/**
 *  author : archer
 *  date : 2019-06-18 11:19
 *  description :
 */

import 'package:flutter/material.dart';

class MyFollowPage extends StatefulWidget {
  @override
  _MyFollowPageState createState() => _MyFollowPageState();
}

class _MyFollowPageState extends State<MyFollowPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              width: 120,
              height: 120,
              decoration: ShapeDecoration(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("resource/images/stars.jpg")))),
          Container(
            width: 180.0,
            height: 180.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage("resource/images/stars.jpg"),
                  fit: BoxFit.fill
              )
            ),
          ),
//          ClipRect(
//            clipBehavior: Clip.antiAliasWithSaveLayer,
//            child: Container(
//              width: 100,
//              height: 100,
//              color: Colors.blue,
//            ),
//          )
        ],
      ),
    );
  }
}
