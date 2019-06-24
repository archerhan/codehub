/**
 *  author : archer
 *  date : 2019-06-24 09:58
 *  description :
 */

import 'package:codehub/common/dao/dao_reslut.dart';
import 'package:codehub/network/api.dart';
import 'package:codehub/network/http_manager.dart';

class MyFollowDao {
  static getMyFollowReceived(String userName, {int page = 1,bool needDb = false}) async {
    if (userName == null) {
      return null;
    }

    next() async {
      String url = Api.getEventReceived(userName) + Api.getPageParams("?", page);
      DataResult res = httpManager.request(url, null, null, null);
      if (res != null && res.result) {

      }
    }

    return await next();
  }

  static getMyFollowDao(String userName, {int page = 1,bool needDb = false}) async {
    next() async {
      String url = Api.getEvent(userName) + Api.getPageParams("?", page);
      DataResult res = httpManager.request(url, null, null, null);

    }

    return await next();
  }
}


