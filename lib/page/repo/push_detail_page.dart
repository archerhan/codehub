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
  _renderItem(e) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Text("path"),
        ),
        Expanded(
          child: CardItem(
            margin: EdgeInsets.all(10),
            child: Container(
              height: 30,
              width: 300,
              child: Text("file"),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reposName),
      ),
      body: EasyRefresh(
        onRefresh: null,
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
                child: CardItem(
                  margin: EdgeInsets.all(10),
                  color: Colors.black87,
                  child: Container(
                    height: 120,
                    child: Text(
                      "this is the header",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     (BuildContext context, int index) {
            //       return _renderItem(null);
            //     },
            //     childCount: 10,
            //   ),
            // ),
            
          ],
        ),
      ),
    );
  }
}
