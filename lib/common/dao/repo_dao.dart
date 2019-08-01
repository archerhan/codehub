/**
 *  author : archer
 *  date : 2019-06-27 21:58
 *  description :
 */

import 'dart:io';
import 'dart:convert';

import 'package:codehub/network/api.dart';
import 'package:codehub/network/http_manager.dart';
import 'package:codehub/common/dao/dao_reslut.dart';
import 'package:dio/dio.dart';
import 'package:codehub/common/model/repo_commit.dart';
import 'package:codehub/common/model/follow_event.dart';
import 'package:codehub/common/model/repository.dart';
import 'package:codehub/common/db/provider/repo_event_db_provider.dart';
import 'package:codehub/common/db/provider/repo_detail_db_provider.dart';
import 'package:codehub/common/db/provider/repo_commit_db_provider.dart';
import 'package:codehub/common/db/provider/repo_readme_db_provider.dart';
import 'package:codehub/common/model/file.dart';
import 'package:codehub/common/model/user.dart';

class ReposDao {
  ///获取用户对当前仓库的star、watch状态
  static getRepositoryStatusDao(userName, reposName) async {
    //star
    String urls = Api.resolveStarRepos(userName, reposName);
    //watch
    String urlw = Api.resolveWatcherRepos(userName, reposName);
    var starRes = await httpManager.request(
        urls, null, null, Options(contentType: ContentType.text),
        noTip: true);
    var watchRes = await httpManager.request(
        urlw, null, null, Options(contentType: ContentType.text),
        noTip: true);
    var data = {"star": starRes.result, "watch": watchRes.result};
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
      for (int i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        list.add(data['name']);
      }
      return DataResult(list, true);
    } else {
      return DataResult(null, false);
    }
  }

  static getReposCommitsDao(userName, repoName,
      {page = 0, branch = "master", needDb = true}) async {
    String fullName = userName + "/" + repoName;
    RepoCommitDbProvider provider = RepoCommitDbProvider();
    next() async {
      String url = Api.getReposCommits(userName, repoName) +
          Api.getPageParams("?", page) +
          "&sha=" +
          branch;
      var res = await httpManager.request(url, null, null, null);
      if (res != null && res.result) {
        List<RepoCommit> list = List();
        var data = res.data;
        if (data == null && data.length == 0) {
          return DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(RepoCommit.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(fullName, branch, json.encode(data));
        }
        return DataResult(list, true);
      } else {
        return DataResult(null, false);
      }
    }

    if (needDb) {
      //处理查询数据库
      List<RepoCommit> list = await provider.getData(fullName, branch);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next());
      return dataResult;
    }

    return await next();
  }

  ///仓库活动事件
  static getRepositoryEventDao(userName, repoName,
      {page = 0, branch = "master", needDb = true}) async {
    String fullName = userName + '/' + repoName;
    RepoEventDbProvider provider = RepoEventDbProvider();
    next() async {
      String url =
          Api.getReposEvent(userName, repoName) + Api.getPageParams("?", page);
      var res = await httpManager.request(url, null, null, null);
      if (res != null && res.result) {
        List<FollowEvent> list = List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(FollowEvent.fromJson(data[i]));
        }
        if (needDb) {
          provider.insertEvent(fullName, json.encode(data));
        }
        return DataResult(list, true);
      } else {
        return DataResult(null, false);
      }
    }

    if (needDb) {
      List<FollowEvent> events = await provider.getEvents(fullName);
      if (events == null) {
        return await next();
      }
      DataResult dataResult = DataResult(events, true, next: next());
      return dataResult;
    }
    return await next();
  }

  ///获取仓库详情
  static getRepositoryDetailDao(userName, repoName, branch,
      {needDb = true}) async {
    String fullName = userName + '/' + repoName;
    RepoDetailDbProvider provider = RepoDetailDbProvider();
    next() async {
      String url = Api.getReposDetail(userName, repoName) + "?ref=" + branch;
      var res = await httpManager.request(url, null,
          {"Accept": 'application/vnd.github.mercy-preview+json'}, null);
      if (res != null && res.result && res.data.length > 0) {
        var data = res.data;
        if (data == null || data.length == 0) {
          return DataResult(null, false);
        }
        Repository repo = Repository.fromJson(data);
        var issueResult =
            await ReposDao.getRepositoryIssueStatusDao(userName, repoName);
        if (issueResult != null && issueResult.result) {
          repo.allIssueCount = int.parse(issueResult.data);
        }
        if (needDb) {
          //插入数据
          provider.insertDetail(fullName, json.encode(data));
        }
//        saveHistoryDao(
//            fullName, DateTime.now(), json.encode(repository.toJson()));
        return DataResult(repo, true);
      } else {
        return DataResult(null, false);
      }
    }

    if (needDb) {
      //查询数据
      Repository repository = await provider.getRepository(fullName);
      if (repository == null) {
        return await next();
      }

      DataResult dataResult = DataResult(repository, true, next: next());
      return dataResult;
    }
    return await next();
  }

  ///获取Issue总数
  static getRepositoryIssueStatusDao(userName, repoName) async {
    String url =
        Api.getReposIssue(userName, repoName, null, null, null) + "&per_page=1";
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
    return DataResult(null, false);
  }

  //readme
  static getRepositoryDetailReadmeDao(userName, repoName, branch,
      {needDb = true}) async {
    RepoReadMeDbProvider provider = RepoReadMeDbProvider();
    String fullName = userName + "/" + repoName;
    next() async {
      String url = Api.readmeFile(userName + '/' + repoName, branch);
      var res = await httpManager.request(
          url,
          null,
          {"Accept": 'application/vnd.github.VERSION.raw'},
          new Options(contentType: ContentType.text));
      if (res != null && res.result) {
        if (needDb) {
          provider.insert(fullName, branch, res.data);
        }
        return new DataResult(res.data, true);
      }
      return new DataResult(null, false);
    }

    if (needDb) {
      //数据库查询
      String readmeDataString =
          await provider.getReadmeDataString(fullName, branch);
      if (readmeDataString != null && readmeDataString.length > 0) {
        return DataResult(readmeDataString, true, next: next());
      } else {
        return await next();
      }
    }

    return await next();
  }

  ///获取仓库文件列表
  static getReposFileDirDao(userName, reposName,
      {path = '', branch, text = false, isHtml = false}) async {
    String url = Api.reposDataDir(userName, reposName, path, branch);
    var res = await httpManager.request(
        url,
        null,
        isHtml
            ? {"Accept": 'application/vnd.github.html'}
            : {"Accept": 'application/vnd.github.VERSION.raw'},
        Options(contentType: text ? ContentType.text : ContentType.json));
    if (res != null && res.result) {
      if (text) {
        return DataResult(res.data, true);
      }
      List<FileModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      List<FileModel> dirs = [];
      List<FileModel> files = [];
      for (int i = 0; i < data.length; i++) {
        FileModel file = FileModel.fromJson(data[i]);
        if (file.type == 'file') {
          files.add(file);
        } else {
          dirs.add(file);
        }
      }
      list.addAll(dirs);
      list.addAll(files);
      return new DataResult(list, true);
    } else {
      return DataResult(null, false);
    }
  }

  /**
   * 用户的仓库
   */
  static getUserRepositoryDao(userName, page, sort, {needDb = false}) async {
    // UserReposDbProvider provider = new UserReposDbProvider();
    next() async {
      String url = Api.userRepos(userName, sort) + Api.getPageParams("&", page);
      var res = await httpManager.request(url, null, null, null);
      if (res != null && res.result && res.data.length > 0) {
        List<Repository> list = new List();
        var dataList = res.data;
        if (dataList == null || dataList.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < dataList.length; i++) {
          var data = dataList[i];
          list.add(Repository.fromJson(data));
        }
        if (needDb) {
          // provider.insert(userName, json.encode(dataList));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      // List<Repository> list = await provider.geData(userName);
      // if (list == null) {
      //   return await next();
      // }
      // DataResult dataResult = new DataResult(list, true, next: next);
      // return dataResult;
    }
    return await next();
  }

  /**
   * 获取用户所有star
   */
  static getStarRepositoryDao(userName, page, sort, {needDb = false}) async {
    // UserStaredDbProvider provider = new UserStaredDbProvider();
    next() async {
      String url = Api.userStar(userName, sort) + Api.getPageParams("&", page);
      var res = await httpManager.request(url, null, null, null);
      if (res != null && res.result && res.data.length > 0) {
        List<Repository> list = new List();
        var dataList = res.data;
        if (dataList == null || dataList.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < dataList.length; i++) {
          var data = dataList[i];
          list.add(Repository.fromJson(data));
        }
        if (needDb) {
          // provider.insert(userName, json.encode(dataList));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      // List<Repository> list = await provider.geData(userName);
      // if (list == null) {
      //   return await next();
      // }
      // DataResult dataResult = new DataResult(list, true, next: next);
      // return dataResult;
    }
    return await next();
  }
}
