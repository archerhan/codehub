/**
 *  author : archer
 *  date : 2019-06-27 10:05
 *  description : 仓库详情 - 详情
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:codehub/common/dao/repo_dao.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/common/utils/common_utils.dart';
import 'package:codehub/page/repo/repo_detail_page.dart';
import 'package:codehub/widget/repo/common_markdown_widget.dart';
import 'package:scoped_model/scoped_model.dart';

class RepoDetailReadmePage extends StatefulWidget {
  final String userName;

  final String reposName;

  RepoDetailReadmePage(this.userName, this.reposName, {Key key})
      : super(key: key);

  @override
  RepoDetailReadmePageState createState() => RepoDetailReadmePageState();
}

class RepoDetailReadmePageState extends State<RepoDetailReadmePage>
    with AutomaticKeepAliveClientMixin {
  bool isShow = false;
  String markDownData;

  RepoDetailReadmePageState();

  refreshReadme() {
    ReposDao.getRepositoryDetailReadmeDao(widget.userName, widget.reposName,
            ReposDetailModel.of(context).currentBranch)
        .then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markDownData = res.data;
          });
          return res.next;
        }
      }
      return Future.value(null);
    }).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markDownData = res.data;
          });
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    isShow = true;
    super.initState();
    refreshReadme();
  }

  @override
  void dispose() {
    isShow = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var markdownWidget = (markDownData == null)
        ? Center(
            child: Container(
              width: 200.0,
              height: 200.0,
              padding: EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitDoubleBounce(
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Container(
                    child: Text(
                      "加载中...",
                      style: CustomTextStyle.middleText,
                    ),
                  )
                ],
              ),
            ),
          )
        : CommonMarkdownWidget(
            markdownData: markDownData,
          );
    return ScopedModelDescendant<ReposDetailModel>(
      builder: (context, child, model) {
        print("=====$markDownData====");
        return markdownWidget;
      },
    );
  }
}
