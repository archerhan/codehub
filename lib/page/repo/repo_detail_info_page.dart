/**
 *  author : archer
 *  date : 2019-06-27 10:05
 *  description : 仓库详情 - 动态
 */

import 'package:flutter/rendering.dart';
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
import 'package:codehub/widget/common/nested_refresh_widget.dart';
import 'package:codehub/common/utils/event_utils.dart';
import 'package:codehub/widget/repo/sliver_header_delegate.dart';
import 'package:codehub/widget/repo/repo_header_item.dart';
import 'package:codehub/widget/common/select_item_widget.dart';

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

  ///主动触发下拉刷新
  @override
  showRefreshLoading(){
    Future.delayed(Duration(seconds: 0),(){

      refreshIKey.currentState.show().then((e){

      });
      return true;
    });
  }

  ///获取列表数据
  _getDataLogic() async {
    if (selectedIndex == 1) {
      return await ReposDao.getReposCommitsDao(widget.userName, widget.repoName,
          page: page,
          branch: ReposDetailModel.of(context).currentBranch,
          needDb: false);
    }
    return await ReposDao.getRepositoryEventDao(
        widget.userName, widget.repoName,
        page: page,
        branch: ReposDetailModel.of(context).currentBranch,
        needDb: false);
  }

  ///获取详情数据
  _getRepoDetail() async {
    ReposDao.getRepositoryDetailDao(widget.userName, widget.repoName,
            ReposDetailModel.of(context).currentBranch)
        .then((result) {
      if (result != null && result.result) {
        setState(() {
          widget.titleOptionControl.url = result.data.htmlUrl;
        });
        ReposDetailModel.of(context).repository = result.data;
        return result.next;
      }
      return new Future.value(null);
    }).then((result) {
      if (result != null && result.result) {
        if (!isShow) {
          return;
        }
        setState(() {
          widget.titleOptionControl.url = result.data.htmlUrl;
        });
        ReposDetailModel.of(context).repository = result.data;
      }
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
        needImage: false,
      );
    }
    return FollowItem(
      FollowEventViewModel.fromFollowMap(
          pullLoadingWidgetControl.dataList[index]),
      onPressed: () {
        EventUtils.ActionUtils(
            context,
            pullLoadingWidgetControl.dataList[index],
            widget.userName + "/" + widget.repoName);
      },
    );
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


    print("刷新");
    _getRepoDetail();
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    print("加载更多");
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
        return NestedRefreshWidget(
          (BuildContext context, int index) => _renderEventItem(index),
          handleRefresh,
          onLoadMore,
          pullLoadingWidgetControl,
          refreshKey: refreshIKey,
          headerSliverBuilder: (context, _) {
            return _sliverBuilder(context, _);
          },
          scrollController: scrollController,
        );
      },
    );
  }

  ///绘制内置Header，支持部分停靠支持
  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      ///头部信息
      SliverPersistentHeader(
        delegate: SliverHeaderDelegate(
            minHeight: headerSize,
            maxHeight: headerSize,
            snapConfig: FloatingHeaderSnapConfiguration(
              vsync: this,
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 10),
            ),
            child: RepoHeaderItem(
              RepoHeaderItemViewModel.fromHttpMap(widget.userName,
                  widget.repoName, ReposDetailModel.of(context).repository),
              layoutListener: (size) {
                setState(() {
                  headerSize = size.height;
                });
              },
            )),
      ),

      SliverPersistentHeader(
        pinned: true,
        delegate: SliverHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            changeSize: true,
            snapConfig: FloatingHeaderSnapConfiguration(
              vsync: this,
              curve: Curves.bounceInOut,
              duration: Duration(milliseconds: 10),
            ),
            builder: (BuildContext context, double shrinkOffset,
                bool overlapsContent) {
              ///根据数值计算偏差
              var lr = 10 - shrinkOffset / 60 * 10;
              var radius = Radius.circular(4 - shrinkOffset / 60 * 4);
              return SizedBox.expand(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, left: lr, right: lr),
                  child: new SelectItemWidget(
                    [
                      "动态",
                      "提交",
                    ],
                    (index) {
                      ///切换时先滑动
                      scrollController
                          .animateTo(0,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceInOut)
                          .then((_) {
                        selectedIndex = index;
                        clearData();
                        showRefreshLoading();
                      });
                    },
                    margin: EdgeInsets.zero,
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(radius),
                    ),
                  ),
                ),
              );
            }),
      ),
    ];
  }
}
