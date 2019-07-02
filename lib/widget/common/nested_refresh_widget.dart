/**
 *  author : archer
 *  date : 2019-07-01 10:13
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; //加载小动画
import 'package:codehub/common/constant/global_style.dart';
import 'package:codehub/widget/common/nested_refresh.dart';
import 'package:codehub/widget/common/common_refresh_widget.dart';

class NestedRefreshWidget extends StatefulWidget {
  ///item builder
  final IndexedWidgetBuilder itemBuilder;

  ///上拉加载
  final RefreshCallback onLoadMore;

  ///下拉刷新
  final RefreshCallback onRefresh;

  ///控制器, 数据
  final RefreshWidgetControl refreshControl;

  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder;

  final ScrollController scrollController;

  ///就是个key
  final Key refreshKey;

  NestedRefreshWidget(
      this.itemBuilder,
      this.onLoadMore,
      this.onRefresh,
      this.refreshControl,
      {
        this.refreshKey,
        this.headerSliverBuilder,
        this.scrollController
      });

  @override
  _NestedRefreshWidgetState createState() => _NestedRefreshWidgetState(
      this.refreshControl,
      this.itemBuilder,
      this.onRefresh,
      this.onLoadMore,
      this.refreshKey);
}

class _NestedRefreshWidgetState extends State<NestedRefreshWidget> {
  final IndexedWidgetBuilder itemBuilder;
  final RefreshCallback onLoadMore;
  final RefreshCallback onRefresh;
  final RefreshWidgetControl refreshControl;
  final Key refreshKey;

  _NestedRefreshWidgetState(this.refreshControl, this.itemBuilder,
      this.onLoadMore, this.onRefresh, this.refreshKey);

  @override
  void initState() {
    super.initState();
  }

  ///根据配置状态返回实际列表数量
  ///实际上这里可以根据你的需要做更多的处理
  ///比如多个头部，是否需要空页面，是否需要显示加载更多。
  _getListCount() {
    if (refreshControl.needHeader) {
      ///如果需要头部，用Item 0 的 Widget 作为ListView的头部
      ///列表数量大于0时，因为头部和底部加载更多选项，需要对列表数据总数+2
      return (refreshControl.dataList.length > 0)
          ? refreshControl.dataList.length + 2
          : refreshControl.dataList.length + 1;
    } else {
      ///如果不需要头部，在没有数据时，固定返回数量1用于空页面呈现
      if (refreshControl.dataList.length == 0) {
        return 1;
      }

      ///如果有数据,因为部加载更多选项，需要对列表数据总数+1
      return (refreshControl.dataList.length > 0)
          ? refreshControl.dataList.length + 1
          : refreshControl.dataList.length;
    }
  }

  ///根据配置状态返回实际列表渲染Item
  _getItem(int index) {
    if (!refreshControl.needHeader &&
        index == refreshControl.dataList.length &&
        refreshControl.dataList.length != 0) {
      ///如果不需要头部，并且数据不为0，当index等于数据长度时，渲染加载更多Item（因为index是从0开始）
      return _buildProgressIndicator();
    } else if (refreshControl.needHeader &&
        index == _getListCount() - 1 &&
        refreshControl.dataList.length != 0) {
      ///如果需要头部，并且数据不为0，当index等于实际渲染长度 - 1时，渲染加载更多Item（因为index是从0开始）
      return _buildProgressIndicator();
    } else if (!refreshControl.needHeader &&
        refreshControl.dataList.length == 0) {
      ///如果不需要头部，并且数据为0，渲染空页面
      return _buildEmpty();
    } else {
      ///回调外部正常渲染Item，如果这里有需要，可以直接返回相对位置的index
      return itemBuilder(context, index);
    }
  }

  Widget _buildProgressIndicator() {
    Widget bottomWidget = (refreshControl.needLoadMore.value)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitWave(
                color: Theme.of(context).primaryColor,
              ),
              Container(
                width: 5.0,
              ),
              Text(
                '加载中...',
                style: TextStyle(
                    color: Color(0xFF121917),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        : Container();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: bottomWidget,
      ),
    );
  }

  _buildEmpty() {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Image(
              image: AssetImage(CustomIcons.DEFAULT_USER_ICON),
              width: 70,
              height: 70,
            ),
          ),
          Container(
            child: Text(
              "暂无数据",
              style: CustomTextStyle.normalText,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollViewRefreshIndicator(
      key: refreshKey,
      child: NestedScrollView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        headerSliverBuilder: widget.headerSliverBuilder,
        body: NotificationListener(
          onNotification: (ScrollNotification p){
            if (p.metrics.pixels >=
                p.metrics.maxScrollExtent) {
              if (this.refreshControl.needLoadMore.value) {
                this.onRefresh?.call();
              }
            }
          },
          child: ListView.builder(
            itemBuilder: (_, index){
              return _getItem(index);
            },
            itemCount: _getListCount(),
          ),
        ),
      ),
      onRefresh: onRefresh,
    );
  }
}

