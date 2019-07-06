/**
 *  author : archer
 *  date : 2019-07-06 22:18
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/db/sql_provider.dart';
import 'package:sqflite/sqflite.dart';

class RepoReadMeDbProvider extends BaseDbProvider {
  final name = "RepoReadme";

  final columnId = "_id";
  final columnFullName = "fullName";
  final columnBranch = "branch";
  final columnData = "data";

  int id;
  String fullName;
  String branch;
  String data;

  RepoReadMeDbProvider();

  Map<String, dynamic> toMap(String fullName,String branch, String dataMapString) {
    Map<String, dynamic> map = {columnFullName : fullName, columnBranch : branch, columnData : data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepoReadMeDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    branch = map[columnBranch];
    data = map[columnData];
  }


  @override
  tableName() {
    return name;
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

  Future _getProvider(Database db ,String fullName, String branch) async {
    List<Map<String, dynamic>> maps = await db.query(name, columns: [columnId, columnFullName, columnData],where: "$columnFullName = ? and $columnBranch = ?", whereArgs: [fullName, branch]);
    if (maps.length > 0) {
      RepoReadMeDbProvider provider = RepoReadMeDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  Future insert(String fullName, String branch, String dataStr) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      await db.delete(name, where: "$columnFullName = ? and $columnBranch = ? ", whereArgs: [fullName, branch]);
    }
    return db.insert(name, toMap(fullName, branch, dataStr));
  }

  Future<String> getReadmeDataString(String fullName, String branch) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      return provider.data;
    }
    return null;
  }

}