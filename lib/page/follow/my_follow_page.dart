/**
 *  author : archer
 *  date : 2019-06-18 11:19
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/dao/my_follow_dao.dart';

class MyFollowPage extends StatefulWidget {
  @override
  _MyFollowPageState createState() => _MyFollowPageState();
}

class _MyFollowPageState extends State<MyFollowPage> {

  @override
  void initState() {
    super.initState();
    MyFollowDao.getMyFollowReceived("archerhan");
    MyFollowDao.getMyFollowDao("archerhan");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("MyFollow"),
      ),
    );
  }
}
