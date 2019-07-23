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
import 'package:codehub/widget/common/common_refresh_widget.dart';

class IssueDetailPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String issueNum;

  final bool needHomeIcon;

  final RefreshWidgetControl refreshWidgetControl = RefreshWidgetControl();

  IssueDetailPage(this.userName, this.reposName, this.issueNum,
      {this.needHomeIcon = false});
  @override
  _IssueDetailPageState createState() => _IssueDetailPageState();
}

class _IssueDetailPageState extends State<IssueDetailPage>
    with AutomaticKeepAliveClientMixin {
  final OptionControl titleOptionControl = OptionControl();

  _getDataLogic() async {
    return await IssueDao.getIssueComment(
        widget.userName, widget.reposName, widget.issueNum);
  }

  _getHeaderInfo() async {
    IssueDao.getIssueInfo(widget.userName, widget.reposName, widget.issueNum)
        .then((res) {
      print(res);
    }).then((res) {});
  }

  Future<Null> refresh() async {
    await Future.delayed(Duration(milliseconds: 500), () {
      _getDataLogic();
      _getHeaderInfo();
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
        body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView.separated(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  height: 44,
                  child: Center(
                    child: Text("This is index"),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
            )));
  }

  @override
  bool get wantKeepAlive => true;
}
