/*
 * @Description: 趋势页面的bloc
 * @Author: ArcherHan
 * @Date: 2019-08-02 14:19:35
 * @LastEditors: ArcherHan
 * @LastEditTime: 2019-08-02 16:18:20
 */

import 'package:codehub/common/dao/repo_dao.dart';
import 'package:codehub/common/model/trend_repo_mode.dart';
import 'package:rxdart/rxdart.dart';

class TrendBloc {
  bool _requested = false;
  bool _isLoading = false;
  
  ///是否正在请求
  bool get isLoading => _isLoading;
  ///是否已经请求过
  bool get requested => _requested;

  ///rxdart 实现的 stream
  var _subject = PublishSubject<List<TrendingRepoModel>>();
  
  Observable<List<TrendingRepoModel>> get stream => _subject.stream;

  Future<void> reqeustRefresh(selectTime, selectType) async {
    _isLoading = true;
    var res = await ReposDao.getTrendDao(since: selectTime.value,languageType: selectType.value);
    if (res != null && res.result) {
      _subject.add(res.data);
    }
    await doNext(res);
    _isLoading = false;
    _requested = true;
    return;
  }

  doNext(res) async {
    if (res.next != null) {
      var resNext = await res.next();
      if (resNext != null && resNext.result) {
        _subject.add(resNext.data);
      }
    }
  }
}
