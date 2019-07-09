/**
 *  author : archer
 *  date : 2019-07-08 10:59
 *  description :
 */

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:codehub/common/dao/dao_reslut.dart';
import 'package:codehub/network/api.dart';
import 'package:codehub/network/http_manager.dart';
import 'package:codehub/common/model/issue.dart';
import 'package:codehub/common/db/provider/repo_issue_db_provider.dart';


class IssueDao {
  static getRepositoryIssueDao(userName, repoName, state, {sort, direction, page = 0,needDb = false}) async {
    String fullName = userName + "/" + repoName;
    String dbState = state ?? "*";
    RepoIssueDbProvider provider = RepoIssueDbProvider();
    next() async {
      String url = Api.getReposIssue(userName, repoName, state, sort, direction) + Api.getPageParams("&", page);
      var res = await httpManager.request(url, null, {"Accept": 'application/vnd.github.html,application/vnd.github.VERSION.raw'}, null);
      if (res != null && res.result) {
        List<Issue> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++){
          list.add(Issue.fromJson(data[i]));
        }
        if (needDb) {
          //存数据
          provider.insert(fullName, state, json.encode(data));
        }
        return DataResult(list, true);
      }
      else {
        return DataResult(null, true);
      }
    }
    if (needDb) {
      //取数据
      List<Issue> list = await provider.getData(fullName, dbState);
      if (list == null || list.length == 0) {
        return await next();
      }
      else {
        return DataResult(list, true, next: next());
      }
    }
    return await next();
  }

  static searchRepositoryIssue(q, name, reposName, state, {page = 1}) async {
    String qu;
    if (state == null || state == 'all') {
      qu = q + "+repo%3A${name}%2F${reposName}";
    } else {
      qu = q + "+repo%3A${name}%2F${reposName}+state%3A${state}";
    }
    String url = Api.repositoryIssueSearch(qu) + Api.getPageParams("&", page);
    var res = await httpManager.request(url, null, null, null);
    if (res != null && res.result) {
      List<Issue> list = new List();
      var data = res.data["items"];
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(Issue.fromJson(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

}