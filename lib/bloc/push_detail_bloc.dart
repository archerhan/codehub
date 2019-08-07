import 'package:codehub/common/dao/repo_dao.dart';
import 'package:codehub/common/model/push_commit.dart';
import 'package:rxdart/rxdart.dart';

class PushDetailBloc {
  bool _requested = false;
  bool _isLoading = false;
    ///是否正在请求
  bool get isLoading => _isLoading;
  ///是否已经请求过
  bool get requested => _requested;

    ///rxdart 实现的 stream
  var _subject = PublishSubject<List<PushCommit>>();
  Observable<List<PushCommit>> get stream => _subject.stream;

  Future<void> requestRefresh(userName,repoName,sha) async {
    _isLoading = true;
    var res = ReposDao.getReposCommitsInfoDao(userName, repoName, sha);
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