/**
 *  author : archer
 *  date : 2019-07-05 11:37
 *  description :
 */

import 'package:codehub/common/utils/code_utils.dart';
import 'package:codehub/common/db/sql_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:codehub/common/model/repo_commit.dart';
import 'package:flutter/foundation.dart';

class RepoCommitDbProvider extends BaseDbProvider {
  final String name = 'RepositoryCommits';
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnBranch = "branch";
  final String columnData = "data";

  int id;
  String fullName;
  String data;
  String branch;

  RepoCommitDbProvider();

  Map<String, dynamic> toMap(
      String fullName, String branch, String dataMapString) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnBranch: branch,
      columnData: dataMapString
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepoCommitDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    branch = map[columnBranch];
    data = map[columnData];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnFullName text not null,
        $columnBranch text not null,
        $columnData text not null)
      ''';
  }

  @override
  tableName() {
    return name;
  }

  Future _getProvider(Database db, String fullName, String branch) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnFullName, columnBranch, columnData],
        where: "$columnFullName = ? and $columnBranch = ?",
        whereArgs: [fullName, branch]);
    if (maps.length > 0) {
      RepoCommitDbProvider provider = RepoCommitDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String fullName, String branch, String dataMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      await db.delete(name,
          where: "$columnFullName = ? and $columnBranch = ?",
          whereArgs: [fullName, branch]);
    }
    return await db.insert(name, toMap(fullName, branch, dataMapString));
  }

  ///获取事件数据
  Future<List<RepoCommit>> getData(String fullName, String branch) async {
    Database db = await getDataBase();

    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      List<RepoCommit> list = new List();

      ///使用 compute 的 Isolate 优化 json decode
      List<dynamic> eventMap =
          await compute(CodeUtils.decodeListResult, provider.data as String);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(RepoCommit.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
