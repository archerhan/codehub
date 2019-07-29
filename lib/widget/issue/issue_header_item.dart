/*
 * @Description: Issue 的Header
 * @Author: ArcherHan
 * @Date: 2019-07-26 17:46:20
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-07-29 11:00:14
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
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Text("userName",style: TextStyle(fontSize: 22,color: Colors.white),),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  "time",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _renderIssueStatusInfo() {
    Color issueStatusColor = "open" == "open" ? Colors.green : Colors.red;
    return Container(
        height: 30,
        child: Row(
          children: <Widget>[
            IconTextWidget(CustomIcons.ISSUE_ITEM_ISSUE, " open",
                TextStyle(color: issueStatusColor), issueStatusColor, 12),
            Text(" #90",style: TextStyle(color: Colors.white,fontSize: 12)),
            IconTextWidget(CustomIcons.ISSUE_ITEM_COMMENT,"number",TextStyle(color: Colors.white),Colors.white,12),
          ],
        ));
  }

  _renderIssueDetail() {
    return Container(
      child: Text(
        "this is the imnm,nnkk s is t达到发he imnm,nnkk s is,nnkk s is t达到发he imnm,nnkk s is,nnkk s is t达到发he imnm,nnkk s is,nnkk s is t达到发he imnm,nnkk s is,nnkk s is t达到发he imnm,nnkk s is t达到发he imnm,nnkk s is t达到发he imnm,nnkk s is t达到发he imnm,nnkk s is t达到发he iss444",
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 12,color: Colors.white),
      ),
    );
  }
  _renderClosedByInfo(){
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "this is a test sentence",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardItem(
      color: Colors.black87,
      margin: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: UserIcon(
              height: 50,
              width: 50,
              image:
                  "https://avatars0.githubusercontent.com/u/28807639?s=400&u=a456773f327cc2f7f7263b645b3945512f76f1d7&v=4",
              onPressed: () {
                print("点击了用户头像");
              },
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _renderAuthorWithTime(),
                  _renderIssueStatusInfo(),
                  _renderIssueDetail(),
                  _renderClosedByInfo()
                ],
              ),
            ),
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
