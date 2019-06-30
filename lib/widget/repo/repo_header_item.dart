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
  ///仓库底部信息
  _getBottomItem(IconData icon, String text, onPressed) {
    return Expanded(
      child: Center(
        child: RawMaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
          child: IconTextWidget(
            icon,
            text,
            CustomTextStyle.smallSubLightText,
            Color(CustomColors.subLightTextColor),
            15.0,
            padding: 3.0,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
  ///单个话题item
  _renderTopicItem(BuildContext context, String item, index) {
    return RawMaterialButton(
      key: index == widget.repoHeaderItemViewModel.topics.length - 1 ? layoutLastTopicKey : null,
      onPressed: () {
        RouteManager.gotoCommonList(context, item, "repository", "topics",userName: item,reposName: "");
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.all(0.0),
      constraints: const BoxConstraints(minHeight: 0.0,minWidth: 0.0),
      child: Container(
        padding: EdgeInsets.only(left: 5.0,right: 5.0,bottom: 2.5,top: 2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          color: Colors.white30,
          border: Border.all(color: Colors.white30,width: 0.0),
        ),
        child: Text(
          item,
          style: CustomTextStyle.smallSubLightText,
        ),
      ),
    );
  }
  ///话题组控件
  _renderTopicGroup(BuildContext context) {
    if (widget.repoHeaderItemViewModel.topics == null || widget.repoHeaderItemViewModel.topics.length == 0) {
      return Container();
    }
    List<Widget> list = List();
    for (int i = 0; i < widget.repoHeaderItemViewModel.topics.length; i++) {
      var item = widget.repoHeaderItemViewModel.topics[i];
      list.add(_renderTopicItem(context, item, i));
    }
    return Container(
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
        ? "fork 于 " +
        widget.repoHeaderItemViewModel.repositoryParentName +
        '\n'
        : "创建于" +
        widget.repoHeaderItemViewModel.created_at +
        "\n";

    String updateStr = "最后提交于" +
        widget.repoHeaderItemViewModel.push_at;

    return createStr +
        ((widget.repoHeaderItemViewModel.push_at != null) ? updateStr : '');
  }

  @override
  void didUpdateWidget(RepoHeaderItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration(seconds: 0),(){
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
//      key: ,
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
    this.repositoryName = repositoryName;
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
