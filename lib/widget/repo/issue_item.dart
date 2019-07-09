/**
 *  author : archer
 *  date : 2019-07-08 21:05
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/model/issue.dart';
import 'package:codehub/common/utils/common_utils.dart';
import 'package:codehub/widget/common/icon_text_widget.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/widget/repo/common_markdown_widget.dart';
import 'package:codehub/widget/follow/card_item.dart';
import 'package:codehub/widget/common/user_icon_widget.dart';
import 'package:codehub/common/route/route_manager.dart';

class IssueItem extends StatelessWidget {
  final IssueItemViewModel issueItemViewModel;

  ///点击
  final GestureTapCallback onPressed;

  ///长按
  final GestureTapCallback onLongPress;

  ///是否需要底部状态
  final bool hideBottom;

  ///是否需要限制内容行数
  final bool limitComment;

  IssueItem(this.issueItemViewModel,
      {this.onPressed,
      this.onLongPress,
      this.hideBottom = false,
      this.limitComment = true});

  _renderBottomContainer() {
    Color issueStateColor =
        issueItemViewModel.state == "open" ? Colors.green : Colors.red;
    return hideBottom
        ? Container()
        : Row(
            children: <Widget>[
              IconTextWidget(
                CustomIcons.ISSUE_ITEM_ISSUE,
                issueItemViewModel.state,
                TextStyle(
                  color: issueStateColor,
                  fontSize: CustomTextStyle.smallTextSize,
                ),
                issueStateColor,
                15.0,
                padding: 2.0,
              ),
              Padding(padding: EdgeInsets.all(2.0)),
              Expanded(
                child: Text(
                  issueItemViewModel.issueTag,
                  style: CustomTextStyle.smallSubText,
                ),
              ),
              IconTextWidget(
                CustomIcons.ISSUE_ITEM_COMMENT,
                issueItemViewModel.commentCount,
                CustomTextStyle.smallSubText,
                Color(CustomColors.subTextColor),
                15.0,
                padding: 2.0,
              )
            ],
          );
  }

  _renderCommentText() {
    return (limitComment)
        ? Container(
            child: Text(
              issueItemViewModel.issueComment,
              style: CustomTextStyle.smallSubText,
              maxLines: limitComment ? 2 : 1000,
            ),
            margin: EdgeInsets.only(top: 6.0, bottom: 2.0),
            alignment: Alignment.topLeft,
          )
        : CommonMarkdownWidget(
            markdownData: issueItemViewModel.issueComment,
          );
  }

  @override
  Widget build(BuildContext context) {
    return CardItem(
      child: InkWell(
        onTap: onPressed,
        onLongPress: onPressed,
        child: Padding(
          padding:
              EdgeInsets.only(left: 5.0, top: 5.0, right: 10.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              UserIcon(
                width: 30.0,
                height: 30.0,
                image: issueItemViewModel.actionUserPic,
                onPressed: () {
                  RouteManager.goPerson(context, issueItemViewModel.actionUser);
                },
              ),
              new Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        ///用户名
                        new Expanded(
                            child: new Text(issueItemViewModel.actionUser,
                                style: CustomTextStyle.smallTextBold)),
                        new Text(
                          issueItemViewModel.actionTime,
                          style: CustomTextStyle.smallSubText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    ///评论内容
                    _renderCommentText(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          left: 0.0, top: 2.0, right: 0.0, bottom: 0.0),
                    ),
                    _renderBottomContainer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IssueItemViewModel {
  String actionTime = "---";
  String actionUser = "---";
  String actionUserPic = "---";
  String issueComment = "---";
  String commentCount = "---";
  String state = "---";
  String issueTag = "---";
  String number = "---";
  String id = "";

  IssueItemViewModel();

  IssueItemViewModel.fromMap(Issue issueMap, {needTitle = true}) {
    String fullName = CommonUtils.getFullName(issueMap.repoUrl);
    actionTime = CommonUtils.getNewsTimeStr(issueMap.createdAt);
    actionUser = issueMap.user.login;
    actionUserPic = issueMap.user.avatar_url;

    if (needTitle) {
      issueComment = fullName + "- " + issueMap.title;
      commentCount = issueMap.commentNum.toString();
      state = issueMap.state;
      issueTag = "#" + issueMap.number.toString();
      number = issueMap.number.toString();
    } else {
      issueComment = issueMap.body ?? "";
      id = issueMap.id.toString();
    }
  }
}
