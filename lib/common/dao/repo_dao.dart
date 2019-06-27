/**
 *  author : archer
 *  date : 2019-06-27 21:58
 *  description :
 */

import 'dart:io';

import 'package:codehub/network/api.dart';
import 'package:codehub/network/http_manager.dart';
import 'package:codehub/common/dao/dao_reslut.dart';
import 'package:dio/dio.dart';


class ReposDao {


  ///获取用户对当前仓库的star、watch状态
  static getRepositoryStatusDao(userName, reposName) async {
    //star
    String urls = Api.resolveStarRepos(userName, reposName);
    //watch
    String urlw = Api.resolveWatcherRepos(userName, reposName);
    var starRes = await httpManager.request(urls, null, null, Options(contentType: ContentType.text),noTip: true);
    var watchRes = await httpManager.request(urlw, null, null, Options(contentType: ContentType.text), noTip: true);
    var data = {"star" : starRes.result,"watch" : watchRes.result};
    return DataResult(data, true);
  }
  ///获取当前仓库所有分支
  static getBranchesDao(userName, reposName) async {
    String url = Api.getbranches(userName, reposName);
    var res = await httpManager.request(url, null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      List<String> list = List();
      var dataList = res.data;
      if (dataList == null || dataList.length == 0) {
        return DataResult(null, false);
      }
      for(int i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        list.add(data['name']);
      }
      return DataResult(list, true);
    }
    else {
      return DataResult(null, false);
    }
  }




}


