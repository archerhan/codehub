/**
 *  author : archer
 *  date : 2019-06-18 11:24
 *  description :
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:codehub/widget/my/my_header_item.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:codehub/widget/repo/card_item.dart';
import 'package:codehub/widget/common/user_icon_widget.dart';
import 'package:codehub/common/redux/my_state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/model/follow_event.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:codehub/common/dao/my_follow_dao.dart';

enum UserType { individual, organization }

class MyPage extends StatefulWidget {
  static final String routeName = "my";
  final String userName;
  MyPage({this.userName, Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  UserType userType = UserType.individual;
  int page = 0;
  List<FollowEvent> eventList = List();
  List<User> userList = List();

  Store<MyState> _getStore() {
    return StoreProvider.of(context);
  }

  _getUserName() {
    String userNameStr = widget.userName ?? _getStore().state.userInfo.login;
    return userNameStr;
  }

  _getUserInfoData() async {
    bool needDb = widget.userName == null ? false : true;
    await UserDao.getUserInfo(_getUserName(), needDb: needDb).then((res) {
      print("user info loaded~~~~~~~~~~~");
    });
  }

  Future<Null> onRefresh() async {
    page = 0;
    await Future.delayed(Duration(seconds: 0), () {
      _getUserInfoData();
      if (userType == UserType.individual) {
        MyFollowDao.getMyFollowDao(_getUserName(), page: page).then((res) {
          setState(() {
            if (res.data.length > 0 && res.result) {
              eventList.clear();
              eventList.addAll(res.data);
            }
          });
        });
      } else {
        UserDao.getMemberDao(_getUserName(), page).then((res) {
          setState(() {
            if (res.data.length > 0 && res.result) {
              userList.clear();
              userList.addAll(res.data);
            }
          });
        });
      }
    });
  }

  Future<Null> onLoadMore() async {
    page++;
    Future.delayed(Duration(seconds: 0), () {
      if (userType == UserType.individual) {
        MyFollowDao.getMyFollowDao(_getUserName(), page: page).then((res) {
          setState(() {
            if (res.data.length > 0 && res.result) {
              eventList.addAll(res.data);
            }
          });
        });
      } else {
        UserDao.getMemberDao(_getUserName(), page).then((res) {
          setState(() {
            if (res.data.length > 0 && res.result) {
              userList.addAll(res.data);
            }
          });
        });
      }
    });
  }

  ///根据type渲染item
  _renderItem(index) {
    if (index == 0) {
      return MyHeaderItem();
    } else {
      ///个人帐号，显示个人event
      if (userType == UserType.individual) {
        return _renderOrganizationItem(index);
      } else {
        ///组织帐号，显示组织成员
        return _renderOrganizationItem(index);
      }
    }
  }

  _renderIndividualItem(index) {
    return CardItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: UserIcon(
                  image:
                      "https://avatars0.githubusercontent.com/u/28807639?s=400&u=a456773f327cc2f7f7263b645b3945512f76f1d7&v=4",
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: Text("username"),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: Text(
                    "time",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "event detailevent detailevent detailevent detailevent detailevent detail",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "other infomationother infomationother infomationother infomationother infomation",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  _renderOrganizationItem(index) {
    return CardItem(
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: UserIcon(
                image:
                    "https://avatars0.githubusercontent.com/u/28807639?s=400&u=a456773f327cc2f7f7263b645b3945512f76f1d7&v=4",
                onPressed: () {},
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                "username",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
      onRefresh: onRefresh,
      loadMore: onLoadMore,
      autoLoad: true,
      firstRefresh: true,
      child: ListView.builder(
        itemCount: userType == UserType.individual
            ? eventList.length
            : userList.length,
        itemBuilder: (BuildContext context, int index) {
          return _renderItem(index);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
