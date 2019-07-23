/**
 *  author : archer
 *  date : 2019-06-27 10:06
 *  description : 仓库详情 - 文件
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/model/file.dart';
import 'package:codehub/common/dao/repo_dao.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/common/utils/common_utils.dart';
import 'package:codehub/common/route/route_manager.dart';
import 'package:codehub/page/repo/repo_detail_page.dart';
import 'package:codehub/widget/repo/card_item.dart';
import 'package:codehub/widget/common/refresh/common_refresh_state.dart';
import 'package:codehub/widget/common/refresh/common_refresh_widget.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RepoDetailFilePage extends StatefulWidget {
  final String userName;
  final String repoName;

  RepoDetailFilePage(this.userName, this.repoName, {Key key}) : super(key: key);

  @override
  RepoDetailFilePageState createState() => RepoDetailFilePageState();
}

class RepoDetailFilePageState extends State<RepoDetailFilePage>
    with
        AutomaticKeepAliveClientMixin<RepoDetailFilePage>,
        CommonRefreshState<RepoDetailFilePage> {
  String path = '';

  String searchText;
  String issueState;

  List<String> headerList = ["."];

  _renderItem(index) {
    FileItemViewModel fileItemViewModel =
        FileItemViewModel.fromMap(dataList[index]);
    IconData iconData = fileItemViewModel.type == "file"
        ? CustomIcons.REPOS_ITEM_FILE
        : CustomIcons.REPOS_ITEM_DIR;
    Widget trailing = (fileItemViewModel.type == "file")
        ? null
        : new Icon(CustomIcons.REPOS_ITEM_NEXT, size: 12.0);
    return CardItem(
      margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
      child: ListTile(
        title: Text(
          fileItemViewModel.name,
          style: CustomTextStyle.smallSubText,
        ),
        leading: Icon(
          iconData,
          size: 16.0,
        ),
        trailing: trailing,
        onTap: () {
          print("item click");
        },
      ),
    );
  }

  _renderHeader() {
    return Container(
      margin: EdgeInsets.only(left: 3.0, right: 3.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return RawMaterialButton(
            constraints: BoxConstraints(minWidth: 0.0, minHeight: 0.0),
            padding: EdgeInsets.all(4.0),
            onPressed: () {
              print("header click");
            },
            child: Text(
              headerList[index] + ">",
              style: CustomTextStyle.smallText,
            ),
          );
        },
        itemCount: headerList.length,
      ),
    );
  }

  //数据
  _getDataLogic(String searchString) async {
    return await ReposDao.getReposFileDirDao(widget.userName, widget.repoName,
        path: path, branch: ReposDetailModel.of(context).currentBranch);
  }

  ///头部列表点击
  _resolveHeaderClick(index) {
    if (isLoading) {
      Fluttertoast.showToast(msg: "loading...");
      return;
    }
    if (headerList[index] != ".") {
      List<String> newHeaderList = headerList.sublist(0, index + 1);
      String path = newHeaderList.sublist(1, newHeaderList.length).join("/");
      this.setState(() {
        this.path = path;
        headerList = newHeaderList;
      });
      this.showRefreshLoading();
    } else {
      setState(() {
        path = "";
        headerList = ["."];
      });
      this.showRefreshLoading();
    }
  }

  ///Click item
  _resolveItemClick(FileItemViewModel fileItemViewModel) {
    if (fileItemViewModel.type == "dir") {
      if (isLoading) {
        Fluttertoast.showToast(msg: "loading...");
        return;
      }
      this.setState(() {
        headerList.add(fileItemViewModel.name);
      });
      String path = headerList.sublist(1, headerList.length).join("/");
      this.setState(() {
        this.path = path;
      });
      this.showRefreshLoading();
    } else {
      String path = headerList.sublist(1, headerList.length).join("/") +
          "/" +
          fileItemViewModel.name;
      if (CommonUtils.isImageEnd(fileItemViewModel.name)) {
        print(" go to picture viewer");
      } else {
        RouteManager.gotoCodeDetailPlatform(
          context,
          title: fileItemViewModel.name,
          reposName: widget.repoName,
          userName: widget.userName,
          path: path,
          branch: ReposDetailModel.of(context).currentBranch,
        );
      }
    }
  }

  /// 返回按键逻辑
  Future<bool> _dialogExitApp(BuildContext context) {
    if (ReposDetailModel.of(context).currentIndex != 3) {
      return Future.value(true);
    }
    if (headerList.length == 1) {
      return Future.value(true);
    } else {
      _resolveHeaderClick(headerList.length - 2);
      return Future.value(false);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  requestRefresh() async {
    return await _getDataLogic(this.searchText);
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic(this.searchText);
  }

  @override
  void initState() {
    super.initState();
    requestRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color(CustomColors.mainBackgroundColor),
      appBar: AppBar(
        flexibleSpace: _renderHeader(),
        backgroundColor: Color(CustomColors.mainBackgroundColor),
        leading: Container(),
        elevation: 0.0,
      ),
      body: WillPopScope(
        onWillPop: () {
          return _dialogExitApp(context);
        },
        child: ScopedModelDescendant<ReposDetailModel>(
          builder: (context, model, child) {
            return CommonRefreshWidget(
              (BuildContext context, int index) => _renderItem(index),
              onLoadMore,
              handleRefresh,
              pullLoadingWidgetControl,
              refreshKey: refreshIndicatorKey,
            );
          },
        ),
      ),
    );
  }
}

class FileItemViewModel {
  String type;
  String name;
  String htmlUrl;

  FileItemViewModel();

  FileItemViewModel.fromMap(FileModel map) {
    name = map.name;
    type = map.type;
    htmlUrl = map.htmlUrl;
  }
}
