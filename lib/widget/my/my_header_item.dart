/*
 * @Description: 个人中心头部
 * @Author: ArcherHan
 * @Date: 2019-07-29 21:53:47
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-07-29 22:32:12
 */

import 'package:flutter/material.dart';
import 'package:codehub/widget/common/user_icon_widget.dart';
import 'package:codehub/widget/common/icon_text_widget.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/common/utils/common_utils.dart';
import 'package:codehub/common/model/user.dart';

class MyHeaderItem extends StatelessWidget {
  User user = User.empty();

  ///用户简介
  _renderHeadPhotoProfile() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: UserIcon(
            image:
                "https://avatars0.githubusercontent.com/u/28807639?s=400&u=a456773f327cc2f7f7263b645b3945512f76f1d7&v=4",
            width: 80,
            height: 80,
            onPressed: () {
              print("点击了我的头像");
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ///用户名
              Text(
                "userName",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),

              ///个人或组织名
              Text(
                "orgnazition",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              ///简介
              IconTextWidget(CustomIcons.USER_ITEM_COMPANY, "组织简介",
                  TextStyle(color: Colors.grey), Colors.grey, 12),

              ///位置
              IconTextWidget(CustomIcons.USER_ITEM_LOCATION, "地理位置",
                  TextStyle(color: Colors.grey), Colors.grey, 12),
            ],
          ),
        ),
      ],
    );
  }

  ///链接
  _renderLinkInfo() {
    return IconTextWidget(
      CustomIcons.USER_ITEM_LINK,
      "链接地址",
      TextStyle(color: Colors.blue),
      Colors.blue,
      12,
      onPressed: () {
        print("点击了链接");
      },
    );
  }
  
  _renderDescDate(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "这里是描述吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦",
          style:TextStyle(
            color: Colors.grey,
            fontSize: 12
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Text(
          "创建于：2019-07-29",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(10),
      color: Colors.black87,
      child: Column(
        children: <Widget>[
          ///头像简介
          _renderHeadPhotoProfile(),
          ///链接
          _renderLinkInfo(),
          ///描述与创建日期
          _renderDescDate(),
          ///悬浮的header
        ],
      ),
    );
  }
}
