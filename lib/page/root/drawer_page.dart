/**
 *  author : archer
 *  date : 2019-06-18 21:33
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:codehub/common/redux/my_state.dart';
import 'package:codehub/widget/common/user_icon_widget.dart';
import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/route/route_manager.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:codehub/common/db/sql_manager.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<String> _titles = [
    "问题反馈",
    "阅读历史",
    "个人信息",
    "切换主题",
    "语言切换",
    "检测更新",
    "关于",
    loadingTag
  ];

  static const loadingTag = "##loading##"; //表尾标记

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MyState>(
      builder: (context, store) {
        User user = store.state.userInfo;
        return Drawer(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 38.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: user.avatar_url.length > 0
                            ? UserIcon(
                                padding: const EdgeInsets.only(
                                    top: 0.0, right: 5.0, left: 0.0),
                                width: 80.0,
                                height: 80.0,
                                image: user.avatar_url,
                                onPressed: () {
                                  print("点击头像");
                                })
                            : Container(
                                width: 80,
                                height: 80,
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(side: BorderSide.none),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "resource/images/snow_sun.jpg"),
                                      fit: BoxFit.fill),
                                ),
                              ),
                      ),
                      Text(
                        user.login ?? "nickname",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (_titles[index] == loadingTag) {
                        return Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: RaisedButton(
                              child: Text("退出登录"),
                              onPressed: () {
                                UserDao.clearAll(store);
                                DbManager.close();
                                RouteManager.goLogin(context);
                              },
                            ));
                      }
                      return ListTile(
                        title: Text(_titles[index]),
                      );
                    },
                    itemCount: _titles.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
