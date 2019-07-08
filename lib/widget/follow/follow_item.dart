/**
 *  author : archer
 *  date : 2019-06-26 10:13
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/model/follow_event.dart';
import 'package:codehub/common/utils/common_utils.dart';
import 'package:codehub/common/utils/event_utils.dart';
import 'package:codehub/common/model/repo_commit.dart';
import 'package:codehub/common/model/notification.dart' as Model;
import 'package:codehub/widget/common/user_icon_widget.dart';
import 'package:codehub/widget/follow/card_item.dart';

class FollowItem extends StatelessWidget {
  final FollowEventViewModel eventViewModel;
  final VoidCallback onPressed;
  final needImage;
  FollowItem(this.eventViewModel, {this.onPressed, this.needImage = true})
      : super();
  @override
  Widget build(BuildContext context) {
    Widget des = (eventViewModel.actionDesc == null ||
            eventViewModel.actionDesc.length == 0)
        ? Container()
        : Container(
            child: Text(
              eventViewModel.actionDesc,
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xff959595),
              ),
              maxLines: 3,
            ),
            margin: EdgeInsets.only(top: 6.0, bottom: 2.0),
            alignment: Alignment.topLeft,
          );
    Widget userImage = (needImage)
        ? UserIcon(
            padding: const EdgeInsets.only(top: 0.0, right: 5.0, left: 0.0),
            width: 30.0,
            height: 30.0,
            image: eventViewModel.actionUserPic,
            onPressed: () {
              print("点击用户头像, 调到对应个人中心");
            },
          )
        : Container();
    return Container(
      child: CardItem(
        child: FlatButton(
          onPressed: onPressed,
          child: Padding(
            padding:
                EdgeInsets.only(left: 0.0, top: 10.0, right: 0.0, bottom: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    userImage,
                    Expanded(
                      child: Text(
                        eventViewModel.actionUser,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColorDark),
                      ),
                    ),
                    Text(
                      eventViewModel.actionTime,
                      style:
                          TextStyle(fontSize: 12.0, color: Color(0xff959595)),
                    )
                  ],
                ),
                Container(
                  child: Text(
                    eventViewModel.actionTarget,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColorDark),
                  ),
                  margin: EdgeInsets.only(top: 6.0, bottom: 2.0),
                  alignment: Alignment.topLeft,
                ),
                des
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FollowEventViewModel {
  String actionUser;
  String actionUserPic;
  String actionDesc;
  String actionTime;
  String actionTarget;

  FollowEventViewModel.fromFollowMap(FollowEvent event) {
    actionTime = CommonUtils.getNewsTimeStr(event.createdAt);
    actionUser = event.actor.login;
    actionUserPic = event.actor.avatar_url;
    var other = EventUtils.getActionAndDes(event);
    actionDesc = other["des"];
    actionTarget = other["actionStr"];
  }

  FollowEventViewModel.fromCommitMap(RepoCommit eventMap) {
    actionTime = CommonUtils.getNewsTimeStr(eventMap.commit.committer.date);
    actionUser = eventMap.commit.committer.name;
    actionDesc = "sha:" + eventMap.sha;
    actionTarget = eventMap.commit.message;
  }

  FollowEventViewModel.fromNotify(
      BuildContext context, Model.Notification eventMap) {
    actionTime = CommonUtils.getNewsTimeStr(eventMap.updateAt);
    actionUser = eventMap.repository.fullName;
    String type = eventMap.subject.type;
    String status = eventMap.unread ? "未读" : "已读";
    actionDesc = eventMap.reason + "类型 : $type, 状态 : $status";
    actionTarget = eventMap.subject.title;
  }
}
