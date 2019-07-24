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
import 'package:codehub/widget/common/refresh/common_refresh_state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class IssueDetailPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String issueNum;

  final bool needHomeIcon;

  final PullLoadWidgetControl refreshWidgetControl = PullLoadWidgetControl();

  final ScrollController scrollController = ScrollController();

  final GlobalKey<EasyRefreshState> refreshIndicatorKey = GlobalKey<EasyRefreshState>();

  IssueDetailPage(this.userName, this.reposName, this.issueNum,
      {this.needHomeIcon = false});
  @override
  _IssueDetailPageState createState() => _IssueDetailPageState();
}

class _IssueDetailPageState extends State<IssueDetailPage>
    with AutomaticKeepAliveClientMixin {
  final OptionControl titleOptionControl = OptionControl();

  _getDataLogic() async {
    await IssueDao.getIssueComment(widget.userName, widget.reposName, widget.issueNum).then((res){
        print(res);

    });

  }

  _getHeaderInfo() async {

    await IssueDao.getIssueInfo(widget.userName, widget.reposName, widget.issueNum)
        .then((res) {
      // print(res);
    }).then((res) {});
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

    await Future.delayed(Duration(seconds:0),(){
      _getDataLogic().then((res){

      });
    });
  }

  
  @override
  void initState() {
    super.initState();
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
          key: widget.refreshIndicatorKey,
          child: ListView.builder(
            itemCount:10,
            itemExtent: 44,
            itemBuilder: (BuildContext context, int index){
              return Container(
                child: Center(
                  child: Text('this is an item'),
                ),
              );
            },
          ),
          onRefresh: refresh,
          loadMore: loadMore,
        ),
        // body: PullLoadWidget(
        //   (context, index){
        //     return Container(
        //       height: 44,
        //       child: Center(
        //         child: Text("this is an item"),
        //       ),
        //     );
        //   },
        //   widget.refreshWidgetControl,
        //   loadMore,
        //   refresh,
        //   scrollController: widget.scrollController,
        //   refreshKey: widget.refreshIndicatorKey,
        // ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
