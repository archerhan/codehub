import 'package:codehub/common/utils/common_utils.dart';
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
import 'package:codehub/widget/follow/follow_item.dart';

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
  User userInfo = User.empty();

  Store<MyState> _getStore() {
    return StoreProvider.of(context);
  }

  _getUserName() {
    String userNameStr = widget.userName ?? _getStore().state.userInfo.login;
    return userNameStr;
  }

  _getUserInfoData() async {
    // bool needDb = widget.userName == null ? false : true;
    await UserDao.getUserInfo(_getUserName(), needDb: false).then((res) {
      if (res != null && res.result) {
        setState(() {
          userInfo = res.data;
          userType = userInfo.type == "User"
              ? UserType.individual
              : UserType.organization;
        });
      }
    });
  }

  Future<Null> onRefresh() async {
    page = 0;
    await Future.delayed(Duration(seconds: 0), () {
      _getUserInfoData();
      if (userType == UserType.individual) {
        MyFollowDao.getMyFollowDao(_getUserName(), page: page).then((res) {
          if (res.data != null && res.result) {
            setState(() {
              eventList.clear();
              eventList.addAll(res.data);
            });
          }
        });
      } else {
        UserDao.getMemberDao(_getUserName(), page).then((res) {
          if (res.data != null && res.result) {
            setState(() {
              userList.clear();
              userList.addAll(res.data);
            });
          }
        });
      }
    });
  }

  Future<Null> onLoadMore() async {
    page++;
    Future.delayed(Duration(seconds: 0), () {
      if (userType == UserType.individual) {
        MyFollowDao.getMyFollowDao(_getUserName(), page: page).then((res) {
          if (res.data != null && res.result) {
            setState(() {
              eventList.addAll(res.data);
            });
          }
        });
      } else {
        UserDao.getMemberDao(_getUserName(), page).then((res) {
          if (res.data != null && res.result) {
            setState(() {
              userList.addAll(res.data);
            });
          }
        });
      }
    });
  }

  ///根据type渲染item
  _renderItem(index) {
    if (index == 0) {
      return MyHeaderItem(userInfo);
    } else {
      ///个人帐号，显示个人event
      if (userType == UserType.individual) {
        return _renderIndividualItem(index);
      } else {
        ///组织帐号，显示组织成员
        return _renderOrganizationItem(index);
      }
    }
  }

  _renderIndividualItem(index) {
    FollowEvent event = eventList[index - 1];

    return FollowItem(FollowEventViewModel.fromFollowMap(event));
  }

  _renderOrganizationItem(index) {
    User organizationMember = userList[index - 1];
    return CardItem(
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: UserIcon(
                image: organizationMember.avatar_url,
                onPressed: () {},
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                organizationMember.login,
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
    return Scaffold(
      appBar: AppBar(
        title: Text("text"),
      ),
      body: EasyRefresh(
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
