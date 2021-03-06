/**
 *  author : archer
 *  date : 2019-07-08 11:26
 *  description :
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:codehub/common/db/sql_provider.dart';
import 'package:codehub/common/model/issue.dart';
import 'package:codehub/common/utils/code_utils.dart';
import 'package:sqflite/sqflite.dart';

class RepoIssueDbProvider extends BaseDbProvider {
  final String name = 'RepositoryIssue';
  int id;
  String fullName;
  String data;
  String state;

  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnState = "state";
  final String columnData = "data";

  RepoIssueDbProvider();

  Map<String, dynamic> toMap(String fullName, String state, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnState: state,
      columnData: data
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepoIssueDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    state = map[columnState];
    data = map[columnData];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnFullName text not null,
        $columnState text,
        $columnData text not null)
      ''';
  }

  @override
  tableName() {
    return name;
  }

  Future _getProvider(Database db, String fullName, String state) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnFullName, columnState, columnData],
        where: "$columnFullName = ? and $columnState = ?",
        whereArgs: [fullName, state]);
    if (maps.length > 0) {
      RepoIssueDbProvider provider = RepoIssueDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String fullName, String state, String dataMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName, state);
    if (provider != null) {
      await db.delete(name,
          where: "$columnFullName = ? and $columnState = ?",
          whereArgs: [fullName, state]);
    }
    return await db.insert(name, toMap(fullName, state, dataMapString));
  }

  ///获取事件数据
  Future<List<Issue>> getData(String fullName, String branch) async {
    Database db = await getDataBase();

    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      List<Issue> list = new List();

      ///使用 compute 的 Isolate 优化 json decode
      List<dynamic> eventMap =
          await compute(CodeUtils.decodeListResult, provider.data as String);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Issue.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
