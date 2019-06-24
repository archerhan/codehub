/**
 *  author : archer
 *  date : 2019-06-24 09:58
 *  description :
 */

import 'package:codehub/common/dao/dao_reslut.dart';
import 'package:codehub/network/api.dart';
import 'package:codehub/network/http_manager.dart';
import 'package:codehub/common/model/follow_event.dart';

class MyFollowDao {
  static getMyFollowReceived(String userName, {int page = 1,bool needDb = false}) async {
    if (userName == null) {
      return null;
    }

    next() async {
      String url = Api.getEventReceived(userName) + Api.getPageParams("?", page);
      var res = await httpManager.request(url, null, null, null);
      if (res != null && res.result) {
        List<FollowEvent> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return null;
        }
        if (needDb) {
          //todo:创建followevent的表
        }
        for(int i = 0; i < data.length; i++) {
          list.add(FollowEvent.fromJson(data[i]));
        }
        return DataResult(list, true);
      }
      else {
        return null;
      }

    }
    if (needDb) {
      //todo:从表里面取出数据
    }

    return await next();
  }

  static getMyFollowDao(String userName, {int page = 1,bool needDb = false}) async {
    next() async {
      String url = Api.getEvent(userName) + Api.getPageParams("?", page);
      var res = await httpManager.request(url, null, null, null);
      if(res != null && res.result) {
        List<FollowEvent> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return DataResult(list, true);
        }
        if (needDb) {
          //将数据插入表
        }
        for (int i=0; i < data.length; i++){
          list.add(FollowEvent.fromJson(data[i]));
        }
        return DataResult(list, true);
      }
      else {
        return DataResult(null, false);
      }
    }
    if (needDb) {
      //todo:从表里面取出数据
    }
    return await next();
  }
}


