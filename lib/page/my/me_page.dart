/**
 *  author : archer
 *  date : 2019-06-18 11:24
 *  description :
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:codehub/common/route/route_manager.dart';
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
import 'package:codehub/common/utils/event_utils.dart';
import 'package:codehub/widget/repo/sliver_header_delegate.dart';

enum UserType { individual, organization }

class MyPage extends StatefulWidget {
  static final String routeName = "my";
  final String userName;
  MyPage({this.userName, Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  UserType userType = UserType.individual;
  int page = 0;
  double headerSize = 200;
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

  ///刷新
  Future<Null> onRefresh() async {
    page = 0;
    await Future.delayed(Duration(seconds: 0), () {
      UserDao.getUserInfo(_getUserName(), needDb: false).then((res) {
        if (res != null && res.result) {
          setState(() {
            userInfo = res.data;
            userType = userInfo.type == "User"
                ? UserType.individual
                : UserType.organization;
          });
        }
      }).then((res) {
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
    });
  }

  ///加载更多
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
  _renderItem(context, index) {
    ///个人帐号，显示个人event
    if (userType == UserType.individual) {
      return _renderIndividualItem(context, index);
    } else {
      ///组织帐号，显示组织成员
      return _renderOrganizationItem(index);
    }
  }

  _renderIndividualItem(context, index) {
    FollowEvent event = eventList[index];

    return FollowItem(
      FollowEventViewModel.fromFollowMap(event),
      onPressed: () {
        EventUtils.ActionUtils(context, event, "");
      },
    );
  }

  _renderOrganizationItem(index) {
    User organizationMember = userList[index];
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
                onPressed: () {
                  RouteManager.goPerson(context, organizationMember.login);
                },
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
      //查看其他人的主页时需要主页，点击底部tab时不需要
      appBar: widget.userName == null
          ? null
          : AppBar(
              title: Text(widget.userName),
            ),
      body: EasyRefresh(
        onRefresh: onRefresh,
        loadMore: onLoadMore,
        autoLoad: true,
        firstRefresh: true,
        child: CustomScrollView(
          slivers: <Widget>[
            ///头部信息
            SliverPersistentHeader(
                delegate: SliverHeaderDelegate(
              minHeight: headerSize,
              maxHeight: headerSize,
              snapConfig: FloatingHeaderSnapConfiguration(
                vsync: this,
                curve: Curves.bounceInOut,
                duration: const Duration(milliseconds: 10),
              ),
              child: MyHeaderItem(userInfo),
            )),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverHeaderDelegate(
                  minHeight: 60,
                  maxHeight: 60,
                  changeSize: true,
                  snapConfig: FloatingHeaderSnapConfiguration(
                    vsync: this,
                    curve: Curves.bounceInOut,
                    duration: Duration(milliseconds: 10),
                  ),
                  builder: (BuildContext context, double shrinkOffset,
                      bool overlapsContent) {
                    ///根据数值计算偏差
                    var lr = 10 - shrinkOffset / 60 * 10;
                    var radius = Radius.circular(4 - shrinkOffset / 60 * 4);
                    return SizedBox.expand(
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: 10, left: lr, right: lr),
                        child: Container(
                          height: 40,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _renderItem(context, index);
                },
                childCount: userType == UserType.individual
                    ? eventList.length
                    : userList.length,
              ),
            ),
          ],
        ),
        // child: ListView.builder(
        //   itemCount: userType == UserType.individual
        //       ? eventList.length+1
        //       : userList.length+1,
        //   itemBuilder: (BuildContext context, int index) {
        //     return _renderItem(context,index);
        //   },
        // ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
