/**
 *  author : archer
 *  date : 2019-06-18 11:19
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/model/follow_event.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:codehub/common/redux/my_state.dart';
import 'package:codehub/widget/follow/follow_item.dart';
import 'package:codehub/common/utils/event_utils.dart';
import 'package:codehub/bloc/follow_bloc.dart';

class MyFollowPage extends StatefulWidget {
  @override
  _MyFollowPageState createState() => _MyFollowPageState();
}

class _MyFollowPageState extends State<MyFollowPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final FollowBloc followBloc = FollowBloc();
  Store<MyState> _getStore() {
    return StoreProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Null> refresh() async {
    await Future.delayed(const Duration(seconds: 0), () {
      followBloc.requestRefresh(_getStore().state.userInfo.login);
    });
  }

  Future<Null> loadMore() async {
    await Future.delayed(const Duration(seconds: 0), () {
      followBloc.requestLoadMore(_getStore().state.userInfo.login);
    });
  }

  _renderItems(FollowEvent e) {
    FollowEventViewModel eventViewModel = FollowEventViewModel.fromFollowMap(e);
    return FollowItem(
      eventViewModel,
      onPressed: () {
        EventUtils.ActionUtils(context, e, "");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: StreamBuilder(
        stream: followBloc.stream,
        builder: (context, snapShot){
          return EasyRefresh(
            firstRefresh: true,
            onRefresh: refresh,
            onLoad: loadMore,
            child: (snapShot.data == null || snapShot.data.length == 0) ? Container(child: Text("暂无数据"),) : ListView.builder(
              itemCount: snapShot.data.length,
              itemBuilder: (context, index) {
                  return _renderItems(snapShot.data[index]);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  //切换tab保存页面
  bool get wantKeepAlive => true;
}
