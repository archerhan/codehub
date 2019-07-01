/**
 *  author : archer
 *  date : 2019-06-27 10:05
 *  description : 仓库详情 - 动态
 */

import 'package:flutter/material.dart';
import 'package:codehub/widget/common/common_option_widget.dart';
import 'package:codehub/common/dao/repo_dao.dart';
import 'package:codehub/page/repo/repo_detail_page.dart';
import 'package:codehub/widget/follow/follow_item.dart';
import 'package:codehub/widget/common/common_refresh_state.dart';
import 'package:codehub/widget/common/nested_refresh.dart';
import 'package:codehub/common/model/repo_commit.dart';
import 'package:codehub/common/route/route_manager.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:codehub/widget/common/common_refresh_widget.dart';

class RepoDetailInfoPage extends StatefulWidget {
  final String userName;
  final String repoName;
  final OptionControl titleOptionControl;

  RepoDetailInfoPage(this.userName, this.repoName, this.titleOptionControl,
      {Key key})
      : super(key: key);

  @override
  RepoDetailInfoPageState createState() => RepoDetailInfoPageState();
}

class RepoDetailInfoPageState extends State<RepoDetailInfoPage>
    with
        AutomaticKeepAliveClientMixin<RepoDetailInfoPage>,
        CommonRefreshState<RepoDetailInfoPage>,
        TickerProviderStateMixin {
  ///Properties
  int selectedIndex = 0;

  ///滑动监听
  final ScrollController scrollController = ScrollController();
  double headerSize = 270;

  /// NestedScrollView 的刷新状态 GlobalKey ，方便主动刷新使用
  final GlobalKey<NestedScrollViewRefreshIndicatorState> refreshIKey =
      new GlobalKey<NestedScrollViewRefreshIndicatorState>();

  AnimationController animationController;

  ///Fetch Data

  ///获取列表数据
  _getDataLogic() async {
    if (selectedIndex == 1) {
      return await ReposDao.getReposCommitsDao(widget.userName, widget.repoName,
          page: 1,
          branch: ReposDetailModel.of(context).currentBranch,
          needDb: false);
    }
    return await ReposDao.getRepositoryEventDao(
        widget.userName, widget.repoName);
  }

  ///获取详情数据
  _getRepoDetail() async {
    ReposDao.getRepositoryDetailDao(widget.userName, widget.repoName,
            ReposDetailModel.of(context).currentBranch)
        .then((result) {
      print(result);
    });
  }

  ///item
  _renderEventItem(index) {
    if (selectedIndex == 1) {
      return FollowItem(
        FollowEventViewModel.fromCommitMap(
            pullLoadingWidgetControl.dataList[index]),
        onPressed: () {
          RepoCommit model = pullLoadingWidgetControl.dataList[index];
          RouteManager.goPushDetailPage(
              context, widget.userName, widget.repoName, model.sha, false);
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {
    _getRepoDetail();
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScopedModelDescendant<ReposDetailModel>(
      builder: (context, child, model) {
        return CommonRefreshWidget((BuildContext context, int index) {
          _renderEventItem(index);
        }, onLoadMore, handleRefresh, pullLoadingWidgetControl,
            refreshKey: refreshIKey);
      },
    );
  }
}
