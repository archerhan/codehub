/**
 *  author : archer
 *  date : 2019-07-05 10:04
 *  description :
 */

import 'package:flutter/material.dart';
import 'package:codehub/common/db/sql_provider.dart';
import 'package:codehub/common/utils/code_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:codehub/common/model/follow_event.dart';
import 'package:flutter/foundation.dart';

class RepoEventDbProvider extends BaseDbProvider {
  final String name = "RepoEvent";

  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnData = "data";

  int id;
  String fullName;
  String data;

  RepoEventDbProvider();

  Map<String, dynamic> toMap(String fullName, String dataMapString) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnData: dataMapString
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepoEventDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[fullName];
    data = map[data];
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
    $columnData text not null)
    ''';
  }

  Future _getProvider(Database db, String fullName) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnFullName, columnData],
        where: "$columnFullName = ?",
        whereArgs: [fullName]);
    if (maps.length > 0) {
      RepoEventDbProvider provider = RepoEventDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  Future insertEvent(String fullName, String dataMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      await db
          .delete(name, where: "$columnFullName = ?", whereArgs: [fullName]);
    }
    return await db.insert(name, toMap(fullName, dataMapString));
  }

  Future<List<FollowEvent>> getEvents(String fullName) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      List<FollowEvent> list = List();
      List<dynamic> eventMap =
          await compute(CodeUtils.decodeListResult, provider.data as String);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(item);
        }
      }
      return list;
    }
    return null;
  }
}
