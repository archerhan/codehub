/**
 *  author : archer
 *  date : 2019-06-26 22:27
 *  description :
 */

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:codehub/widget/repo/sliver_header_delegate.dart';
import 'package:codehub/widget/repo/card_item.dart';
import 'package:codehub/widget/common/icon_text_widget.dart';
import 'package:codehub/widget/common/user_icon_widget.dart';
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/common/model/push_commit.dart';
import 'package:codehub/common/dao/repo_dao.dart';
import 'package:codehub/bloc/push_detail_bloc.dart';


class PushDetailPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String sha;

  final bool needHomeIcon;

  PushDetailPage(this.sha, this.userName, this.reposName,
      {this.needHomeIcon = false});
  @override
  _PushDetailPageState createState() => _PushDetailPageState();
}

class _PushDetailPageState extends State<PushDetailPage>
    with TickerProviderStateMixin {

  _getDataLogic() async {
    return await ReposDao.getReposCommitsInfoDao(widget.userName, widget.reposName, widget.sha);
  }

  Future<void> refresh()async{
    await _getDataLogic();
  }


  _renderItem() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              "path",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: CardItem(
              child: Container(
                // color: Colors.blue,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        "</>",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text("file"),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _renderHeader() {
    return Container(
        child: CardItem(
      margin: EdgeInsets.all(10),
      color: Colors.black87,
      child: Container(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: UserIcon(
                image:
                    "https://avatars1.githubusercontent.com/u/28807639?s=460&v=4",
                height: 45,
                width: 45,
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      children: <Widget>[
                        IconTextWidget(CustomIcons.PUSH_ITEM_EDIT, "1",
                            TextStyle(color: Colors.grey), Colors.grey, 14),
                        Container(
                          width: 8,
                        ),
                        IconTextWidget(CustomIcons.PUSH_ITEM_ADD, "44",
                            TextStyle(color: Colors.grey), Colors.grey, 14),
                        Container(
                          width: 8,
                        ),
                        IconTextWidget(CustomIcons.PUSH_ITEM_MIN, "9",
                            TextStyle(color: Colors.grey), Colors.grey, 14)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      "time",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      "detail",
                      style: TextStyle(color: Colors.grey),
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reposName),
      ),
      body: EasyRefresh(
        onRefresh: refresh,
        onLoad: null,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: SliverHeaderDelegate(
                  snapConfig: FloatingHeaderSnapConfiguration(
                    vsync: this,
                    curve: Curves.bounceInOut,
                    duration: const Duration(milliseconds: 10),
                  ),
                  minHeight: 120,
                  maxHeight: 120,
                  child: _renderHeader()),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _renderItem();
                },
                childCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
