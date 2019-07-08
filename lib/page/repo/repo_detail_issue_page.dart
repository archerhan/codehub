/**
 *  author : archer
 *  date : 2019-06-27 10:06
 *  description : 仓库详情 - issue
 */

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:codehub/widget/common/common_refresh_state.dart';
import 'package:codehub/widget/common/common_refresh_widget.dart';
import 'package:codehub/widget/common/nested_refresh.dart';
import 'package:codehub/widget/common/nested_refresh_widget.dart';
import 'package:codehub/widget/repo/sliver_header_delegate.dart';
import 'package:codehub/common/dao/issue_dao.dart';



class RepoDetailIssuePage extends StatefulWidget {

  final String userName;
  final String repoName;

  RepoDetailIssuePage(this.userName,this.repoName,{Key key}) : super(key: key);

  @override
  RepoDetailIssuePageState createState() => RepoDetailIssuePageState();
}

class RepoDetailIssuePageState extends State<RepoDetailIssuePage>
    with
        AutomaticKeepAliveClientMixin<RepoDetailIssuePage>,
        SingleTickerProviderStateMixin,
        CommonRefreshState<RepoDetailIssuePage> {

  final GlobalKey<NestedScrollViewRefreshIndicatorState> refreshIKey = GlobalKey<NestedScrollViewRefreshIndicatorState>();

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
      return await IssueDao.getRepositoryIssueDao(widget.userName, widget.repoName, issueState, page: page, needDb: true);
    }
    else {
      return await IssueDao.getRepositoryIssueDao(widget.userName, widget.repoName, this.issueState, page: this.page, needDb: true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataLogic(null);
  }

  @override
  showRefreshLoading() {
    // TODO: implement showRefreshLoading
    return super.showRefreshLoading();
  }

  @override
  requestLoadMore() {
    // TODO: implement requestLoadMore
    return super.requestLoadMore();
  }

  @override
  requestRefresh() {
    // TODO: implement requestRefresh
    return super.requestRefresh();
  }

  @override
  // TODO: implement needHeader
  bool get needHeader => super.needHeader;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  // TODO: implement isRefreshFirst
  bool get isRefreshFirst => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("ISSUE"),
      ),
    );
  }
}
