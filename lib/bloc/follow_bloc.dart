/*
 * @Description: 首页bloc
 * @Author: ArcherHan
 * @Date: 2019-09-11 13:58:13
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-09-11 15:37:28
 */

import 'package:codehub/common/dao/my_follow_dao.dart';
import 'package:codehub/common/model/follow_event.dart';
import 'package:rxdart/rxdart.dart';

class FollowBloc {
  bool _requested = false;

  bool _isLoading = false;

  List<FollowEvent> _list = List<FollowEvent>();

  ///是否正在loading
  bool get isLoading => _isLoading;

  ///是否已经请求过
  bool get requested => _requested;


  int _page = 1;

  var _subject = PublishSubject<List<FollowEvent>>();
  Observable<List<FollowEvent>> get stream => _subject.stream;
  ///刷新可以用缓存
  requestRefresh(String userName) async {
    _isLoading = true;
    pageReset();
    if (_list.length > 0) {
      _list.clear();
    }
    var res = await MyFollowDao.getMyFollowReceived(userName,
        page: _page, needDb: true);
    if (res != null && res.result) {
      _list = res.data;
      _subject.add(_list);
    }
    // await refreshNext(res);
    _isLoading = false;
    _requested = true;
  }
  ///记载更多不应该用缓存，会出错
  requestLoadMore(String userName) async {
    _isLoading = true;
    pageUp();
    var res = await MyFollowDao.getMyFollowReceived(userName,
        page: _page, needDb: false);
    if (res != null && res.result) {
      _list.addAll(res.data);
      _subject.add(_list);
    }
    // await loadMorehNext(res);
    _isLoading = false;
    _requested = true;
  }

  refreshNext(res) async {
    if (res.next != null) {
      var resNext = await res.next();
      if (resNext != null && resNext.result) {
        _list.addAll(resNext.data);
        _subject.add(_list);
      }
    }
  }

    loadMorehNext(res) async {
    if (res.next != null) {
      var resNext = await res.next();
      if (resNext != null && resNext.result) {
        _subject.add(resNext.data);
      }
    }
  }

  pageUp() {
    ++_page;
  }

  pageReset() {
    _page = 1;
    
  }
}
