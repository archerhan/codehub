/**
 *  author : archer
 *  date : 2019-06-29 10:34
 *  description : 仓库详情头部组件
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/model/repository.dart';
import 'package:codehub/common/utils/common_utils.dart';
import 'package:codehub/widget/common/icon_text_widget.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/common/route/route_manager.dart';
import 'package:codehub/common/constant/global_config.dart';
import 'package:codehub/widget/repo/card_item.dart';

class RepoHeaderItem extends StatefulWidget {
  final RepoHeaderItemViewModel repoHeaderItemViewModel;
  final ValueChanged<Size> layoutListener;
  RepoHeaderItem(this.repoHeaderItemViewModel, {this.layoutListener}) : super();

  @override
  _RepoHeaderItemState createState() => _RepoHeaderItemState();
}

class _RepoHeaderItemState extends State<RepoHeaderItem> {
  final GlobalKey layoutKey = new GlobalKey();
  final GlobalKey layoutTopicContainerKey = new GlobalKey();
  final GlobalKey layoutLastTopicKey = new GlobalKey();

  double widgetHeight = 0;

  ///底部仓库状态信息，比如star数量等
  _getBottomItem(IconData icon, String text, onPressed) {
    return new Expanded(
      child: new Center(
          child: new RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
              child: new IconTextWidget(
                icon,
                text,
                CustomTextStyle.smallSubLightText,
                Color(CustomColors.subLightTextColor),
                15.0,
                padding: 3.0,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              onPressed: onPressed)),
    );
  }

  _renderTopicItem(BuildContext context, String item, index) {
    return new RawMaterialButton(
        key: index == widget.repoHeaderItemViewModel.topics.length - 1
            ? layoutLastTopicKey
            : null,
        onPressed: () {
          RouteManager.gotoCommonList(context, item, "repository", "topics",
              userName: item, reposName: "");
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(0.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: new Container(
          padding:
          EdgeInsets.only(left: 5.0, right: 5.0, top: 2.5, bottom: 2.5),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: Colors.white30,
            border: new Border.all(color: Colors.white30, width: 0.0),
          ),
          child: new Text(
            item,
            style: CustomTextStyle.smallSubLightText,
          ),
        ));
  }


  ///话题组控件
  _renderTopicGroup(BuildContext context) {
    if (widget.repoHeaderItemViewModel.topics == null ||
        widget.repoHeaderItemViewModel.topics.length == 0) {
      return Container();
    }
    List<Widget> list = new List();
    for (int i = 0; i < widget.repoHeaderItemViewModel.topics.length; i++) {
      var item = widget.repoHeaderItemViewModel.topics[i];
      list.add(_renderTopicItem(context, item, i));
    }
    return new Container(
      key: layoutTopicContainerKey,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 5.0),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 5.0,
        children: list,
      ),
    );
  }

  ///仓库创建和提交状态信息
  _getInfoText(BuildContext context) {
    String createStr = widget.repoHeaderItemViewModel.repositoryIsFork
        ? "fork 于 " + widget.repoHeaderItemViewModel.repositoryParentName + '\n'
        : "创建于" + widget.repoHeaderItemViewModel.created_at + "\n";

    String updateStr = "最后提交于" + widget.repoHeaderItemViewModel.push_at;

    return createStr +
        ((widget.repoHeaderItemViewModel.push_at != null) ? updateStr : '');
  }

  @override
  void didUpdateWidget(RepoHeaderItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    ///如果没有tag列表，不需要处理
    /*if(layoutTopicContainerKey.currentContext == null || layoutLastTopicKey.currentContext == null) {
      return;
    }*/
    ///如果存在tag，根据tag去判断，修复溢出
    new Future.delayed(Duration(seconds: 0), (){
      /// tag 所在 container
      RenderBox renderBox2 = layoutTopicContainerKey.currentContext?.findRenderObject();
      /// 最后面的一个tag
      RenderBox renderBox3 = layoutLastTopicKey.currentContext?.findRenderObject();
      double overflow = ((renderBox3?.localToGlobal(Offset.zero)?.dy ?? 0) -
          (renderBox2?.localToGlobal(Offset.zero)?.dy ?? 0)) -
          (layoutLastTopicKey.currentContext?.size?.height ?? 0);
      var newSize;
      if(overflow > 0) {
        newSize = layoutKey.currentContext.size.height + overflow;
      } else {
        newSize = layoutKey.currentContext.size.height + 10.0;
      }
      if(GlobalConfig.DEBUG) {
        print("newSize $newSize overflow $overflow");
      }
      if (widgetHeight != newSize && newSize > 0) {
        print("widget?.layoutListener?.call");
        widgetHeight = newSize;
        widget?.layoutListener
            ?.call(Size(layoutKey.currentContext.size.width, widgetHeight));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: layoutKey,
      child: CardItem(
        color: Theme.of(context).primaryColorDark,
        child: ClipRect(
          child: Container(
            ///背景图片
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.repoHeaderItemViewModel.ownerPic ??
                    CustomIcons.DEFAULT_REMOTE_PIC),
                fit: BoxFit.cover,
              ),
            ),

            ///黑色遮罩
            child: Container(
              decoration: BoxDecoration(
                color: Color(CustomColors.primaryDarkValue & 0xA0FFFFFF),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      //名字/仓库名
                      children: <Widget>[
                        RawMaterialButton(
                          constraints:
                              BoxConstraints(minWidth: 0.0, minHeight: 0.0),
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            RouteManager.goPerson(context,
                                widget.repoHeaderItemViewModel.ownerName);
                          },
                          child: Text(
                            widget.repoHeaderItemViewModel.ownerName,
                            style: CustomTextStyle.normalTextActionWhiteBold,
                          ),
                        ),
                        Text(
                          "/",
                          style: CustomTextStyle.normalTextMitWhiteBold,
                        ),
                        Text(
                          "  " + widget.repoHeaderItemViewModel.repositoryName,
                          style: CustomTextStyle.normalTextMitWhiteBold,
                        )
                      ],
                    ),
                    Row(
                      //仓库类型+大小+license
                      children: <Widget>[
                        Text(
                          widget.repoHeaderItemViewModel.repositoryType ?? "--",
                          style: CustomTextStyle.smallSubLightText,
                        ),
                        Text(
                          widget.repoHeaderItemViewModel.repositorySize ?? "--",
                          style: CustomTextStyle.smallSubLightText,
                        ),
                        Text(
                          widget.repoHeaderItemViewModel.license ?? "--",
                          style: CustomTextStyle.smallSubLightText,
                        ),
                      ],
                    ),
                    Container(
                      child: Text(
                        widget.repoHeaderItemViewModel.repositoryDes ?? "---",
                        style: CustomTextStyle.smallSubLightText,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      margin: EdgeInsets.only(top: 6.0, bottom: 2.0),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 6.0, bottom: 2.0, right: 5.0),
                      alignment: Alignment.topRight,
                      child: RawMaterialButton(
                        onPressed: () {
                          if (widget.repoHeaderItemViewModel.repositoryIsFork) {
                            RouteManager.goReposDetail(
                                context,
                                widget.repoHeaderItemViewModel
                                    .repositoryParentUser,
                                widget.repoHeaderItemViewModel.repositoryName);
                          }
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.all(0.0),
                        constraints:
                            BoxConstraints(minHeight: 0.0, minWidth: 0.0),
                        child: Text(_getInfoText(context),
                            style:
                                widget.repoHeaderItemViewModel.repositoryIsFork
                                    ? CustomTextStyle.smallActionLightText
                                    : CustomTextStyle.smallSubLightText),
                      ),
                    ),
                    Divider(
                      color: Color(CustomColors.subTextColor),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ///star
                          _getBottomItem(CustomIcons.REPOS_ITEM_STAR,
                              widget.repoHeaderItemViewModel.repositoryStar,
                              () {
                            RouteManager.gotoCommonList(
                                context,
                                widget.repoHeaderItemViewModel.repositoryName,
                                "user",
                                "repo_star",
                                userName:
                                    widget.repoHeaderItemViewModel.ownerName,
                                reposName: widget
                                    .repoHeaderItemViewModel.repositoryName);
                          }),
                          ///fork
                          Container(
                            width: 0.3,
                            height: 25.0,
                            color: Color(CustomColors.subLightTextColor)
                          ),
                            _getBottomItem(CustomIcons.REPOS_ITEM_FORK,
                                widget.repoHeaderItemViewModel.repositoryFork,
                                () {
                              RouteManager.gotoCommonList(
                                  context,
                                  widget.repoHeaderItemViewModel.repositoryName,
                                  "repository",
                                  "repo_fork",
                                  userName:
                                      widget.repoHeaderItemViewModel.ownerName,
                                  reposName: widget
                                      .repoHeaderItemViewModel.repositoryName);
                            }),
                          ///watch
                          Container(
                            width: 0.3,
                            height: 25.0,
                            color: Color(CustomColors.subLightTextColor)),
                             _getBottomItem(CustomIcons.REPOS_ITEM_WATCH,
                                widget.repoHeaderItemViewModel.repositoryWatch,
                                    () {
                                  RouteManager.gotoCommonList(
                                      context,
                                      widget.repoHeaderItemViewModel.repositoryName,
                                      "user",
                                      "repo_watcher",
                                      userName:
                                      widget.repoHeaderItemViewModel.ownerName,
                                      reposName: widget
                                          .repoHeaderItemViewModel.repositoryName);
                                }),
                          ///issue
                          Container(
                            width: 0.3,
                            height: 25.0,
                            color: Color(CustomColors.subLightTextColor)),
                             _getBottomItem(
                              CustomIcons.REPOS_ITEM_ISSUE,
                              widget.repoHeaderItemViewModel.repositoryIssue,
                                (){
                                if (widget.repoHeaderItemViewModel.allIssueCount == null || widget.repoHeaderItemViewModel.allIssueCount == 0) {
                                  return;
                                }
                                List<String> list = [
                                  "所有Issue " + widget.repoHeaderItemViewModel.allIssueCount.toString(),
                                  "打开的Issue " + widget.repoHeaderItemViewModel.openIssuesCount.toString(),
                                  "关闭的Issue" + (widget.repoHeaderItemViewModel.allIssueCount - widget.repoHeaderItemViewModel.openIssuesCount).toString()
                                ];

                                CommonUtils.showCommitOptionDialog(context, list, (index){print("点击了 $index" + list[index]);});

                                }
                            ),
                        ],
                      ),
                    ),
                    _renderTopicGroup(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RepoHeaderItemViewModel {
  String ownerName = '---';
  String ownerPic;
  String repositoryName = "---";
  String repositorySize = "---";
  String repositoryStar = "---";
  String repositoryFork = "---";
  String repositoryWatch = "---";
  String repositoryIssue = "---";
  String repositoryIssueClose = "";
  String repositoryIssueAll = "";
  String repositoryType = "---";
  String repositoryDes = "---";
  String repositoryLastActivity = "";
  String repositoryParentName = "";
  String repositoryParentUser = "";
  String created_at = "";
  String push_at = "";
  String license = "";
  List<String> topics;
  int allIssueCount = 0;
  int openIssuesCount = 0;
  bool repositoryStared = false;
  bool repositoryForked = false;
  bool repositoryWatched = false;
  bool repositoryIsFork = false;

  RepoHeaderItemViewModel();

  RepoHeaderItemViewModel.fromHttpMap(ownerName, repoName, Repository map) {
    this.ownerName = ownerName;
    if (map == null || map.owner == null) {
      return;
    }
    this.ownerPic = map.owner.avatar_url;
    this.repositoryName = repoName;
    this.allIssueCount = map.allIssueCount;
    this.topics = map.topics;
    this.openIssuesCount = map.openIssuesCount;
    this.repositoryStar =
        map.watchersCount != null ? map.watchersCount.toString() : "";
    this.repositoryFork =
        map.forksCount != null ? map.forksCount.toString() : "";
    this.repositoryWatch =
        map.subscribersCount != null ? map.subscribersCount.toString() : "";
    this.repositoryIssue =
        map.openIssuesCount != null ? map.openIssuesCount.toString() : "";
    //this.repositoryIssueClose = map.closedIssuesCount != null ? map.closed_issues_count.toString() : "";
    //this.repositoryIssueAll = map.all_issues_count != null ? map.all_issues_count.toString() : "";
    this.repositorySize =
        ((map.size / 1024.0)).toString().substring(0, 3) + "M";
    this.repositoryType = map.language;
    this.repositoryDes = map.description;
    this.repositoryIsFork = map.fork;
    this.license = map.license != null ? map.license.name : "";
    this.repositoryParentName = map.parent != null ? map.parent.fullName : null;
    this.repositoryParentUser =
        map.parent != null ? map.parent.owner.login : null;
    this.created_at = CommonUtils.getNewsTimeStr(map.createdAt);
    this.push_at = CommonUtils.getNewsTimeStr(map.pushedAt);
  }
}
