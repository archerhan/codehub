import 'package:codehub/common/route/route_manager.dart';
/**
 *  author : archer
 *  date : 2019-06-29 11:23
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:codehub/common/dao/repo_dao.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:codehub/widget/common/common_user_item.dart';
import 'package:codehub/widget/common/common_repo_item.dart';

class CommonListPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String showType;

  final String dataType;

  final String title;

  CommonListPage(this.title, this.showType, this.dataType,
      {this.userName, this.reposName});
  @override
  _CommonListPageState createState() => _CommonListPageState();
}

class _CommonListPageState extends State<CommonListPage> {
  List dataList = List();
  int page = 0;
  _renderItem(context, index) {
    var data = dataList[index];
    switch (widget.showType) {
      case 'repository':
        RepoItemViewModel repoItemViewModel = RepoItemViewModel.fromMap(data);
        return new RepoItem(
          repoItemViewModel,
          onPressed: () {
            RouteManager.goReposDetail(context, repoItemViewModel.ownerName,
                repoItemViewModel.repositoryName);
          },
        );
      case 'user':
        return new UserItem(UserItemViewModel.fromUserMap(data));
      case 'org':
        return new UserItem(UserItemViewModel.fromOrgMap(data));
      case 'issue':
        return null;
      case 'release':
        return null;
      case 'notify':
        return null;
    }
  }

  _getDataLogic() async {
    switch (widget.dataType) {
      case 'follower':
        return await UserDao.getFollowerListDao(widget.userName, page,
            needDb: page <= 1);
      case 'followed':
        return await UserDao.getFollowedListDao(widget.userName, page,
            needDb: page <= 1);
      case 'user_repos':
        return await ReposDao.getUserRepositoryDao(widget.userName, page, null,
            needDb: page <= 1);
      case 'user_star':
        return await ReposDao.getStarRepositoryDao(widget.userName, page, null,
            needDb: page <= 1);
      case 'repo_star':
      // return await ReposDao.getRepositoryStarDao(
      //     widget.userName, widget.reposName, page,
      //     needDb: page <= 1);
      case 'repo_watcher':
      // return await ReposDao.getRepositoryWatcherDao(
      //     widget.userName, widget.reposName, page,
      //     needDb: page <= 1);
      case 'repo_fork':
      // return await ReposDao.getRepositoryForksDao(
      //     widget.userName, widget.reposName, page,
      //     needDb: page <= 1);
      case 'repo_release':
        return null;
      case 'repo_tag':
        return null;
      case 'notify':
        return null;
      case 'history':
      // return await ReposDao.getHistoryDao(page);
      case 'topics':
      // return await ReposDao.searchTopicRepositoryDao(widget.userName,
      // page: page);
      case 'user_be_stared':
        return null;
      case 'user_orgs':
        return await UserDao.getUserOrgsDao(widget.userName, page,
            needDb: page <= 1);
    }
  }

  Future<Null> onRefresh() async {
    page = 1;
    await Future.delayed(Duration(seconds: 0), () {
      _getDataLogic().then((res) {
        if (res != null && res.result) {
          var list = res.data;
          if (list != null) {
            if (dataList.length > 0) {
              dataList.clear();
            }
            dataList.addAll(list);
            setState(() {});
          }
        }
      });
    });
  }

  Future<Null> onLoadMore() async {
    page++;
    await Future.delayed(Duration(seconds: 0), () {
      _getDataLogic().then((res) {
        if (res != null && res.result) {
          var list = res.data;
          if (list != null) {
            dataList.addAll(list);
            setState(() {});
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
        ),
      ),
      body: EasyRefresh(
        autoLoad: true,
        firstRefresh: true,
        onRefresh: onRefresh,
        loadMore: onLoadMore,
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return _renderItem(context, index);
          },
        ),
      ),
    );
  }
}
