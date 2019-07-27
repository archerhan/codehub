/*
 * @Description: Issue 的Header
 * @Author: ArcherHan
 * @Date: 2019-07-26 17:46:20
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-07-27 14:35:04
 */

import 'package:codehub/widget/issue/issue_item.dart';
import 'package:flutter/material.dart';
import 'package:codehub/common/model/issue.dart';
import 'package:codehub/common/utils/common_utils.dart';
import 'package:codehub/widget/common/user_icon_widget.dart';
import 'package:codehub/widget/common/icon_text_widget.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/widget/repo/card_item.dart';

class IssueHeaderItem extends StatelessWidget {
  final IssueItemViewModel issueItemViewModel;
  final VoidCallback onPressed;
  IssueHeaderItem({this.issueItemViewModel, this.onPressed});

  _renderAuthorWithTime() {
    return Container(
      color: Colors.yellow,
      height: 30.0,
      width: 300,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.green,
                child: Text("userName"),
            ),
          ),
          
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
                child: Text("time",textAlign: TextAlign.right,),
            ),
          ),
        ],
      ),
      ),
      
    );
  }

  _renderIssueStatusInfo() {
    Color issueStatusColor =
        "open" == "open" ? Colors.green : Colors.red;
    return Container(
      color: Colors.purple,
      child: Row(
      children: <Widget>[
        IconTextWidget(CustomIcons.ISSUE_ITEM_COMMENT, "open",
            TextStyle(color: issueStatusColor), issueStatusColor, 12),
      ],
    )
    );

  }
  _renderIssueDetail(){
    return Container(
      color: Colors.cyan,
      child: Center(
        child: Text("this is the issue detailetail,this s is the issue detail",textAlign: TextAlign.left,overflow: TextOverflow.ellipsis,maxLines:3,),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return CardItem(
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserIcon(
            height: 50,
            width: 50,
            image: "https://avatars0.githubusercontent.com/u/28807639?s=400&u=a456773f327cc2f7f7263b645b3945512f76f1d7&v=4",
            onPressed: (){
              print("点击了用户头像");
            },
          ),
          Column(
            // mainAxisSize: MainAxisSize.max,
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Expanded(
              //   flex: 1,
              //   child: _renderAuthorWithTime(),
              // ),
              // Expanded(
              //   flex: 1,
              //   child: _renderIssueStatusInfo(),
              // ),
              // Expanded(
              //   flex: 3,
              //   child: _renderIssueDetail(),
              // ),
              _renderAuthorWithTime(),
              _renderIssueStatusInfo(),
              _renderIssueDetail()
            ],
          ),
        ],
      ),
    );
  }
}

class IssueHeaderViewModel {
  String actionTime = "---";
  String actionUser = "---";
  String actionUserPic;

  String closedBy = "";
  bool locked = false;
  String issueComment = "---";
  String issueDesHtml = "---";
  String commentCount = "---";
  String state = "---";
  String issueDes = "---";
  String issueTag = "---";

  IssueHeaderViewModel();

  IssueHeaderViewModel.fromMap(Issue issueMap) {
    actionTime = CommonUtils.getNewsTimeStr(issueMap.createdAt);
    actionUser = issueMap.user.login;
    actionUserPic = issueMap.user.avatar_url;
    closedBy = issueMap.closeBy != null ? issueMap.closeBy.login : "";
    locked = issueMap.locked;
    issueComment = issueMap.title;
    issueDesHtml = issueMap.bodyHtml != null
        ? issueMap.bodyHtml
        : (issueMap.body != null) ? issueMap.body : "";
    commentCount = issueMap.commentNum.toString() + "";
    state = issueMap.state;
    issueDes = issueMap.body != null ? ": \n" + issueMap.body : '';
    issueTag = "#" + issueMap.number.toString();
  }
}
