/**
 *  author : archer
 *  date : 2019-07-01 11:21
 *  description :
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:codehub/common/constant/global_config.dart';
import 'package:codehub/widget/common/common_refresh_widget.dart';

mixin CommonRefreshState<T extends StatefulWidget> on State<T>, AutomaticKeepAliveClientMixin<T> {
  bool isShow = false;
  bool isLoading = false;
  int page = 1;
  bool isRefreshing = false;
  bool isLoadMoring = false;
  final List dataList = List();
  final RefreshWidgetControl pullLoadingWidgetControl = RefreshWidgetControl();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  _lockToAwait() async {
    doDelayed() async {
      await Future.delayed(Duration(seconds: 1)).then((_)async {
        if(isLoading){
          return await doDelayed();
        }
        else {
          return null;
        }
      });
    }
    await doDelayed();
  }

  showRefreshLoading(){
    Future.delayed(Duration(seconds: 0), (){
      refreshIndicatorKey.currentState.show().then((e){

      });
      return true;
    });
  }

  @protected
  resolveRefreshResult(res){
    if (res != null && res.result) {
      pullLoadingWidgetControl.dataList.clear();
      if (isShow){
        setState(() {
          pullLoadingWidgetControl.dataList.addAll(res.data);
        });
      }
    }
  }

  @protected
  Future<Null> handleRefresh() async {
    if (isLoading) {
      if(isRefreshing) {
        return null;
      }
      await _lockToAwait();
    }
    isLoading = true;
    isRefreshing = true;
    page = 1;
    var res = await requestRefresh();
    resolveRefreshResult(res);
    resolveDataResult(res);
    if (res.next != null) {
      var resNext = await res.next;
      resolveRefreshResult(resNext);
      resolveDataResult(resNext);
    }
    isLoading = false;
    isRefreshing = false;
    return null;
  }

  @protected
  Future<Null> onLoadMore() async {
    if (isLoading) {
      if(isLoadMoring) {
        return null;
      }
      await _lockToAwait();
    }
    isLoading = true;
    isLoadMoring = true;
    page++;
    var res = await requestLoadMore();
    if (res != null && res.result) {
      if (isShow) {
        setState(() {
          pullLoadingWidgetControl.dataList.addAll(res.data);
        });
      }
    }
    resolveDataResult(res);
    isLoading = false;
    isLoadMoring = false;
    return null;
  }

  @protected
  resolveDataResult(res) {
    if (isShow) {
      setState(() {
        pullLoadingWidgetControl.needLoadMore.value = (res != null && res.data != null && res.data.length == GlobalConfig.PAGE_SIZE);
      });
    }
  }

  @protected
  clearData() {
    if (isShow) {
      setState(() {
        pullLoadingWidgetControl.dataList.clear();
      });
    }
  }
  ///下拉刷新数据
  @protected
  requestRefresh() async {}

  ///上拉更多请求数据
  @protected
  requestLoadMore() async {}

  ///是否需要第一次进入自动刷新
  @protected
  bool get isRefreshFirst;

  ///是否需要头部
  @protected
  bool get needHeader => false;

  ///是否需要保持
  @override
  bool get wantKeepAlive => true;

  List get getDataList => dataList;

  @override
  void initState() {
    isShow = true;
    super.initState();
    pullLoadingWidgetControl.needHeader = needHeader;
    pullLoadingWidgetControl.dataList = getDataList;
    if (pullLoadingWidgetControl.dataList.length == 0 && isRefreshFirst) {
      showRefreshLoading();
    }
  }

  @override
  void dispose() {
    isShow = false;
    isLoading = false;
    super.dispose();
  }
}