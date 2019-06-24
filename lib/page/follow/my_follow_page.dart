/**
 *  author : archer
 *  date : 2019-06-18 11:19
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/dao/my_follow_dao.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/dao/dao_reslut.dart';

class MyFollowPage extends StatefulWidget {
  @override
  _MyFollowPageState createState() => _MyFollowPageState();
}

class _MyFollowPageState extends State<MyFollowPage> {

  @override
  void initState() {
    super.initState();
//    DataResult res = UserDao.getUserInLocal();
//    User user = res.data;
//    MyFollowDao.getMyFollowReceived(user.login);
//    MyFollowDao.getMyFollowDao(user.login);
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
