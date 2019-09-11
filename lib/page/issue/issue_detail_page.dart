import 'package:codehub/common/model/issue.dart';
import 'package:codehub/common/utils/common_utils.dart';
/**
 *  author : archer
 *  date : 2019-06-26 22:31
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/dao/issue_dao.dart';
import 'package:codehub/widget/common/custom_title_bar.dart';
import 'package:codehub/widget/common/common_option_widget.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/common/route/route_manager.dart';
import 'package:codehub/widget/common/refresh/pull_load_refresh_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:codehub/widget/issue/issue_header_item.dart';
import 'package:codehub/widget/repo/card_item.dart';
import 'package:codehub/widget/common/user_icon_widget.dart';

class IssueDetailPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String issueNum;

  final bool needHomeIcon;

  final PullLoadWidgetControl refreshWidgetControl = PullLoadWidgetControl();

  final ScrollController scrollController = ScrollController();

  // final GlobalKey<EasyRefreshState> refreshIndicatorKey =
  // GlobalKey<EasyRefreshState>();

  IssueDetailPage(this.userName, this.reposName, this.issueNum,
      {this.needHomeIcon = false});
  @override
  _IssueDetailPageState createState() => _IssueDetailPageState();
}

class _IssueDetailPageState extends State<IssueDetailPage>
    with AutomaticKeepAliveClientMixin {
  final OptionControl titleOptionControl = OptionControl();

  IssueHeaderViewModel issueHeaderViewModel = IssueHeaderViewModel();

  List<Issue> dataList = List();
  _getDataLogic() async {
    await IssueDao.getIssueComment(
            widget.userName, widget.reposName, widget.issueNum)
        .then((res) {
      if (res.data.length > 0) {
        dataList.clear();
        dataList = res.data;
      }
      setState(() {});
    }).then((res) {});
  }

  _getHeaderInfo() async {
    await IssueDao.getIssueInfo(
            widget.userName, widget.reposName, widget.issueNum)
        .then((res) {
      ///刷新头部数据
      _resolveHeaderData(res);
    }).then((res) {});
  }

  _resolveHeaderData(res) {
    Issue issue = res.data;
    setState(() {
      issueHeaderViewModel = IssueHeaderViewModel.fromMap(issue);
    });
  }

  Future<Null> refresh() async {
    print("下拉刷新啦");

    await Future.delayed(Duration(milliseconds: 0), () {
      _getDataLogic();
      _getHeaderInfo();
    });
  }

  Future<Null> loadMore() async {
    print("上拉加载啦");

    await Future.delayed(Duration(seconds: 0), () {
      _getDataLogic().then((res) {});
    });
  }

  @override
  void initState() {
    super.initState();
  }

  _renderIssueDetailItem(index) {
    if (index == 0) {
      return IssueHeaderItem(issueHeaderViewModel);
    } else {
      Issue issue = dataList[index - 1];
      return CardItem(
        color: Colors.white,
        margin: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: UserIcon(
                height: 30,
                width: 30,
                image: issue.user.avatar_url,
                onPressed: () {
                  print("pressed");
                },
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _renderAuthorWithTime(issue),
                    _renderIssueDetail(issue)
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  _renderAuthorWithTime(Issue issue) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Text(
                  issue.user.login,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  CommonUtils.getNewsTimeStr(issue.createdAt),
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

  _renderIssueDetail(Issue issue) {
    return Container(
      child: Text(
        issue.body,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget widgetContent =
        widget.needHomeIcon ? null : CommonOptionWidget(titleOptionControl);
    return Scaffold(
      appBar: AppBar(
        title: CustomTitleBar(
          widget.reposName,
          rightWidget: widgetContent,
          needRightLocalIcon: widget.needHomeIcon,
          iconData: CustomIcons.HOME,
          onPressed: () {
            RouteManager.goReposDetail(
                context, widget.userName, widget.reposName);
          },
        ),
      ),
      body: EasyRefresh(
        firstRefresh: true,
        // key: widget.refreshIndicatorKey,
        child: ListView.builder(
          itemCount: dataList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return _renderIssueDetailItem(index);
          },
        ),
        onRefresh: refresh,
        onLoad: loadMore,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
