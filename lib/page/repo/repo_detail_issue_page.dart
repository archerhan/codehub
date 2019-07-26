/**
 *  author : archer
 *  date : 2019-06-27 10:06
 *  description : 仓库详情 - issue
 */

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:codehub/widget/common/refresh/common_refresh_state.dart';
import 'package:codehub/widget/common/refresh/common_refresh_widget.dart';
import 'package:codehub/widget/common/refresh/nested_refresh.dart';
import 'package:codehub/widget/common/refresh/nested_refresh_widget.dart';
import 'package:codehub/widget/repo/sliver_header_delegate.dart';
import 'package:codehub/common/dao/issue_dao.dart';
import 'package:codehub/widget/issue/issue_item.dart';
import 'package:codehub/common/route/route_manager.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/widget/common/custom_search_bar_widget.dart';
import 'package:codehub/widget/common/select_item_widget.dart';

class RepoDetailIssuePage extends StatefulWidget {
  final String userName;
  final String repoName;

  RepoDetailIssuePage(this.userName, this.repoName, {Key key})
      : super(key: key);

  @override
  RepoDetailIssuePageState createState() => RepoDetailIssuePageState();
}

class RepoDetailIssuePageState extends State<RepoDetailIssuePage>
    with
        AutomaticKeepAliveClientMixin<RepoDetailIssuePage>,
        SingleTickerProviderStateMixin,
        CommonRefreshState<RepoDetailIssuePage> {
  final GlobalKey<NestedScrollViewRefreshIndicatorState> refreshIKey =
      new GlobalKey<NestedScrollViewRefreshIndicatorState>();

  ///搜索 issue 文本
  String searchText;

  ///过滤 issue 状态
  String issueState;

  ///显示 issue 状态 tag index
  int selectIndex;

  ///滑动控制器
  final ScrollController scrollController = new ScrollController();

  ///fetch data
  _getDataLogic(String searchString) async {
    if (searchString == null || searchString.length == 0) {
      return await IssueDao.getRepositoryIssueDao(
          widget.userName, widget.repoName, issueState,
          page: page, needDb: true);
    } else {
      return await IssueDao.searchRepositoryIssue(
          searchString, widget.userName, widget.repoName, this.issueState,
          page: this.page);
    }
  }

  _renderIssueItem(index) {
    IssueItemViewModel issueItemViewModel =
        IssueItemViewModel.fromMap(pullLoadingWidgetControl.dataList[index]);
    return IssueItem(
      issueItemViewModel,
      onPressed: () {
        RouteManager.goIssueDetail(context, widget.userName, widget.repoName,
            issueItemViewModel.number);
      },
    );
  }

  _resolveSelectedIndex() {
    clearData();
    switch (selectIndex) {
      case 0:
        issueState = null;
        break;
      case 1:
        issueState = "open";
        break;
      case 2:
        issueState = "closed";
        break;
      default:
        break;
    }
    scrollController
        .animateTo(0,
            duration: Duration(milliseconds: 100), curve: Curves.bounceIn)
        .then((_) {
      showRefreshLoading();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataLogic(null);
  }

  @override
  showRefreshLoading() {
    Future.delayed(Duration(seconds: 0), () {
      refreshIKey.currentState.show().then((e) {});
      return true;
    });
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic(searchText);
  }

  @override
  requestRefresh() async {
    return await _getDataLogic(searchText);
  }

  @override
  bool get needHeader => false;

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  clearData() {
    if (isShow) {
      setState(() {
        pullLoadingWidgetControl.dataList.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //这里是为什么
    return Scaffold(
      backgroundColor: Color(CustomColors.mainBackgroundColor),
      appBar: AppBar(
        leading: Container(),
        flexibleSpace: CustomSearchBarWidget((value) {
          this.searchText = value;
        }, (value) {
          _resolveSelectedIndex();
        }, () {
          _resolveSelectedIndex();
        }),
        elevation: 0.0,
        backgroundColor: Color(CustomColors.mainBackgroundColor),
      ),
      body: NestedRefreshWidget(
        (BuildContext context, int index) => _renderIssueItem(index),
        handleRefresh,
        onLoadMore,
        pullLoadingWidgetControl,
        refreshKey: refreshIKey,
        scrollController: scrollController,
        headerSliverBuilder: (context, _) {
          return _sliverBuilder(context, _);
        },
      ),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    double height = 60.0;
    return <Widget>[
      SliverPersistentHeader(
        pinned: true,

        /// SliverPersistentHeaderDelegate 的实现
        delegate: SliverHeaderDelegate(
            maxHeight: height,
            minHeight: height,
            changeSize: true,
            snapConfig: FloatingHeaderSnapConfiguration(
              vsync: this,
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 10),
            ),
            builder: (BuildContext context, double shrinkOffset,
                bool overlapsContent) {
              ///根据数值计算偏差
              var lr = 10 - shrinkOffset / height * 10;
              var radius = Radius.circular(4 - shrinkOffset / height * 4);
              return SizedBox.expand(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: lr, bottom: 10, left: lr, right: lr),
                  child: new SelectItemWidget(
                    [
                      "全部",
                      "打开",
                      "关闭",
                    ],
                    (selectIndex) {
                      this.selectIndex = selectIndex;
                      _resolveSelectedIndex();
                    },
                    margin: EdgeInsets.all(0.0),
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
