/**
 *  author : archer
 *  date : 2019-06-21 09:47
 *  description :
 */

import 'dart:convert';
import 'package:codehub/common/constant/global_config.dart';
import 'package:codehub/common/local/local_storage.dart';
import 'package:codehub/network/http_manager.dart';
import 'package:codehub/network/api.dart';
import 'package:dio/dio.dart';
import 'package:codehub/common/dao/dao_reslut.dart';
import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/db/provider/user_info_db_provider.dart';
import 'package:codehub/common/redux/user_redux.dart';
import 'package:redux/redux.dart';


class UserDao {
  static login(userName, password,Store store) async {
    String type = userName + ":" + password;
    var bytes = utf8.encode(type);
    var base64Str = base64.encode(bytes);
    if (GlobalConfig.DEBUG) {
      print("base64Str + login " + base64Str);
    }
    await LocalStorage.save(GlobalConfig.USER_ACCOUNT_KEY, userName);
    await LocalStorage.save(GlobalConfig.USER_BASIC_CODE_KEY, base64Str);

    Map requestParam = {
      "scopes": ['user', 'repo', 'gist', 'notifications'],
      "note": "admin_script",
//      "client_id": GlobalConfig.CLIENT_ID,
//      "client_secret": GlobalConfig.CLIENT_SECRET
    };
    httpManager.clearAuthorization();
    Options options = Options();
    options.headers["Authorization"] = base64Str;
    options.method = "post";
    var res = await httpManager.request(Api.getAuthorization(), json.encode(requestParam), null, options);
    var resultData = null;
    if (res != null && res.result) {
      await LocalStorage.save(GlobalConfig.USER_PWD_KEY, password);
      //请求user数据, 在适当的时机存储
      var resultData = await getUserInfo(null);
      if (GlobalConfig.DEBUG) {
//        print("user result " + resultData.result.toString());
//        print(resultData.data);
        print(res.data.toString());
      }

      store.dispatch(UpdateUserAction(resultData.data));

    }
    return DataResult(resultData, res.result);

  }

  static initUserInfo(Store store) async {
    String token = await LocalStorage.get(GlobalConfig.USER_TOKEN_KEY);
    DataResult res = await getUserInLocal();
    if (res != null && res.result && token != null) {
      store.dispatch(UpdateUserAction(res.data));
    }
    return DataResult(res.data,(res.result && token != null));
  }

  static getUserInfo(userName , {needDB = true}) async {
    UserInfoDbProvider provider = UserInfoDbProvider();
    next() async {
      var res;
      if (userName == null) {
        res = await httpManager.request(Api.getMyUserInfo(), null, null, null);
      }
      else {
        res = await httpManager.request(Api.getUserInfo(userName), null, null, null);
      }

      if (res != null && res.result) {
        String starred = "---";
        if (res.data["type"] != "Organization") {
          var countRes = await getUserStaredCountNet(res.data["login"]);
          if (res.result) {
            starred = countRes.data;
          }
        }
        User user = User.fromJson(res.data);
        user.starred = starred;
        if (userName == null) {
          LocalStorage.save(GlobalConfig.USER_INFO, json.encode(user.toJson()));
        }
        else {
          if (needDB) {
            provider.insert(userName, json.encode(user.toJson()));
          }
        }
        return new DataResult(user, true);
      }
      else {
        return new DataResult(res.data, false);
      }
    }

    if (needDB) {
      User user = await provider.getUserInfo(userName);
      if (user == null) {
        return await next();
      }
      DataResult dataResult = DataResult(user, true, next: next());
      return dataResult;
    }

    return await next();
  }
  //获取本地存储的user
  static getUserInLocal() async {
    var userText = await LocalStorage.get(GlobalConfig.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      User user = User.fromJson(userMap);
      return DataResult(user, true);
    }
    else {
      return DataResult(null, false);
    }
  }

  static clearAll(Store store) async {
    httpManager.clearAuthorization();
    LocalStorage.remove(GlobalConfig.USER_INFO);
    store.dispatch(UpdateUserAction(User.empty()));
  }

  ///在header中提起stared count
  static getUserStaredCountNet(userName) async {
    String url = Api.userStar(userName, null) + "&per_page=1";
    var res = await httpManager.request(url, null, null, null);
    if (res != null && res.result && res.headers != null) {
      try {
        List<String> link = res.headers['link'];
        if (link != null) {
          int indexStart = link[0].lastIndexOf("page=") + 5;
          int indexEnd = link[0].lastIndexOf(">");
          if (indexStart >= 0 && indexEnd >= 0) {
            String count = link[0].substring(indexStart, indexEnd);
            return new DataResult(count, true);
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

}


































