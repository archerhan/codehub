/**
 *  author : archer
 *  date : 2019-06-27 10:05
 *  description : 仓库详情 - 动态
 */

import 'package:flutter/material.dart';
import 'package:codehub/widget/common/common_option_widget.dart';
import 'package:codehub/common/dao/repo_dao.dart';
import 'package:codehub/page/repo/repo_detail_page.dart';

class RepoDetailInfoPage extends StatefulWidget {
  final String userName;
  final String repoName;
  final OptionControl titleOptionControl;

  RepoDetailInfoPage(this.userName, this.repoName, this.titleOptionControl,{Key key}) : super(key: key);

  @override
  RepoDetailInfoPageState createState() => RepoDetailInfoPageState();
}

class RepoDetailInfoPageState extends State<RepoDetailInfoPage> with
    AutomaticKeepAliveClientMixin<RepoDetailInfoPage>,
    TickerProviderStateMixin {
  ///Properties
  int selectedIndex = 0;

  ///Fetch Data

  ///获取列表数据
  _getDataLogic() async {
    if(selectedIndex == 1) {
      return await ReposDao.getReposCommitsDao(widget.userName, widget.repoName, page: 1, branch: ReposDetailModel.of(context).currentBranch, needDb: false);
    }
    return await ReposDao.getRepositoryEventDao(widget.userName, widget.repoName);
  }

  ///获取详情数据
  _getRepoDetail() async {
    ReposDao.getRepositoryDetailDao(widget.userName, widget.repoName, ReposDetailModel.of(context).currentBranch).then((result){
      print(result);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataLogic();
    _getRepoDetail();
  }
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("动态"),
      ),
    );
  }
}
