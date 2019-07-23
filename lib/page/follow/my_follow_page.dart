/**
 *  author : archer
 *  date : 2019-06-18 11:19
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/dao/my_follow_dao.dart';
import 'package:codehub/common/model/follow_event.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:codehub/common/redux/my_state.dart';
import 'package:codehub/widget/follow/follow_item.dart';
import 'package:codehub/common/utils/event_utils.dart';

class MyFollowPage extends StatefulWidget {
  @override
  _MyFollowPageState createState() => _MyFollowPageState();
}

class _MyFollowPageState extends State<MyFollowPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  var loadingTag = 0; //表尾标记
  var _followList = <FollowEvent>[];
  var _page = 0;
  Store<MyState> _getStore() {
    return StoreProvider.of(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
//    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<Null> refresh() async {
    await Future.delayed(const Duration(seconds: 0), () {
      _fetchData();
    });
  }

  ///Fetch data
  _fetchData() async {
    await MyFollowDao.getMyFollowReceived(_getStore().state.userInfo.login,
            page: _page, needDb: true)
        .then((res) {
      if (res.data != null && res.data.length > 0) {
        for (var item in res.data) {
          _followList.add(item);
        }
        if (_followList.length > 0) {
          loadingTag = _followList.length - 1;
        }
        setState(() {});
      }
    });
  }

  _renderItems(FollowEvent e) {
    FollowEventViewModel eventViewModel = FollowEventViewModel.fromFollowMap(e);
    return FollowItem(
      eventViewModel,
      onPressed: () {
        EventUtils.ActionUtils(context, e, "");
        print("点击了Item");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.separated(
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
                  child: CircularProgressIndicator(strokeWidth: 2.0)),
            );
          } else {
            return _renderItems(_followList[index]);
          }
        },
        separatorBuilder: (context, index) => Divider(height: 0.0),
      ),
    );
  }

  @override
  //切换tab保存页面
  bool get wantKeepAlive => true;
}
