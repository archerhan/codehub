/**
 *  author : archer
 *  date : 2019-06-18 11:19
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/dao/my_follow_dao.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:codehub/common/model/user.dart';
import 'package:codehub/network/result_data.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:codehub/common/redux/my_state.dart';

class MyFollowPage extends StatefulWidget {
  @override
  _MyFollowPageState createState() => _MyFollowPageState();
}

class _MyFollowPageState extends State<MyFollowPage> {


  Store<MyState> _getStore() {
    return StoreProvider.of(context);
  }
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          child: Text("click me"),
          onPressed: () async {
             await MyFollowDao.getMyFollowDao(_getStore().state.userInfo.login, page: 1, needDb: true).then((res){
            });
//             var resp = await MyFollowDao.getMyFollowReceived(_getStore().state.userInfo.login, page: 1, needDb: true);
//             print(resp.data);
          },
        ),
      ),
    );
  }
}
