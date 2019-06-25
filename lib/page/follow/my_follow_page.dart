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
import 'package:codehub/common/model/follow_event.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:codehub/common/redux/my_state.dart';

class MyFollowPage extends StatefulWidget {
  @override
  _MyFollowPageState createState() => _MyFollowPageState();
}

class _MyFollowPageState extends State<MyFollowPage> {
  var loadingTag = 0;//表尾标记
  var _followList = <FollowEvent>[];
  var _page = 0;
  Store<MyState> _getStore() {
    return StoreProvider.of(context);
  }
  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _fetchData();
    });
  }


  ///Fetch data
  _fetchData() async {
    await MyFollowDao.getMyFollowReceived(_getStore().state.userInfo.login, page: _page).then((res){
      if (res.data != null && res.data.length > 0) {
        for(var item in res.data){
          _followList.add(item);
        }
        if (_followList.length > 0) {
          loadingTag = _followList.length - 1;
        }
        setState(() {

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _followList.length,
      itemBuilder: (context, index) {
        if (index == loadingTag) {
          //获取新数据
          _page++;
          _fetchData();
          //显示loading
          return Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0)
            ),
          );
        }
        else {

          return ListTile(
            title: Text(_followList[index].actor.login),
          );

        }
      },
      separatorBuilder: (context, index) => Divider(height: 0.5),
    );
//    return Container(
//      child: Center(
//        child: RaisedButton(
//          child: Text("click me"),
//          onPressed: () async {
//            await MyFollowDao.getMyFollowDao(_getStore().state.userInfo.login, page: 1, needDb: true).then((res){
//
//            });
//            await MyFollowDao.getMyFollowReceived(_getStore().state.userInfo.login, page: 1, needDb: true).then((res){
//
//            });
//          },
//        ),
//      ),
//    );
  }
}
