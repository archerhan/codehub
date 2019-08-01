/*
 * @Description: 通用用户列表展示item，包含icon和用户名
 * @Author: ArcherHan
 * @Date: 2019-08-01 18:00:06
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-08-01 23:21:30
 */

import 'package:flutter/material.dart';
import 'package:codehub/widget/repo/card_item.dart';
import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/model/user_org.dart';
import 'package:codehub/widget/common/user_icon_widget.dart';
import 'package:codehub/common/route/route_manager.dart';

class UserItem extends StatelessWidget {
  final UserItemViewModel userItemViewModel;
  UserItem(this.userItemViewModel);
  @override
  Widget build(BuildContext context) {
    return CardItem(
      child: RawMaterialButton(
        onPressed: () {
          RouteManager.goPerson(context, userItemViewModel.userName);
        },
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: UserIcon(
                    height: 50,
                    width: 50,
                    image: userItemViewModel.userPic,
                    onPressed: () {
                      RouteManager.goPerson(
                          context, userItemViewModel.userName);
                    },
                  ),
                )),
            Expanded(
              flex: 4,
              child: Text(
                userItemViewModel.userName ?? "--",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserItemViewModel {
  String userPic = "--";
  String userName = "--";

  UserItemViewModel.fromUserMap(User user) {
    userPic = user.avatar_url;
    userName = user.login;
  }

  UserItemViewModel.fromOrgMap(UserOrg userOrg) {
    userPic = userOrg.avatarUrl;
    userName = userOrg.login;
  }
}
