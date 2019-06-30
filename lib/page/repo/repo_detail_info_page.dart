/**
 *  author : archer
 *  date : 2019-06-27 10:05
 *  description : 仓库详情 - 动态
 */

import 'package:flutter/material.dart';
import 'package:codehub/widget/common/common_option_widget.dart';


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
