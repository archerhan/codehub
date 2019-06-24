/**
 *  author : archer
 *  date : 2019-06-24 10:00
 *  description :
 */

import 'dart:async';
import 'package:codehub/common/db/sql_provider.dart';
import 'package:codehub/common/model/follow_event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:codehub/common/utils/code_utils.dart';
import 'package:flutter/foundation.dart';

class MyFollowEventDbProvider extends BaseDbProvider {
  final name = "MyFollowEventDbProvider";
  final columnId = "_id";
  final columnUserName = "userName";
  final columnData = "data";

  int id;
  String userName;
  String data;

  MyFollowEventDbProvider();

  Map<String, dynamic> toMap(String userName, String eventMapString) {
    Map<String, dynamic> map = {columnUserName : userName, columnData : eventMapString};
    if (id != null){
      map[columnId] = id;
    }
    return map;
  }

  MyFollowEventDbProvider.fromMap(Map map){
    id = map[columnId];
    userName = map[columnUserName];
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
        $columnUserName text not null,
        $columnData text not null)
      ''';
  }

  Future<MyFollowEventDbProvider> _getProvider(Database db, String userName) async {
    List<Map> maps = await db.query(
        name,
        columns: [
          columnId,
          columnUserName,
          columnData
        ],
        where: "$userName = ?",
        whereArgs: [userName]
    );
    if (maps.length > 0) {
      MyFollowEventDbProvider provider = MyFollowEventDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  Future insert(String userName, String eventMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, userName);
    if (provider != null) {
      await db.delete(name, where: "$columnUserName = ?",whereArgs: [userName]);
    }
    return await db.insert(name, toMap(userName, eventMapString));
  }

  Future<List<FollowEvent>> getMyFollowEvent(userName) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, userName);
    if (provider != null) {
      List<FollowEvent> list = List();

      List<dynamic> eventMaps = await compute(CodeUtils.decodeListResult,provider.data as String);
      if (eventMaps.length > 0) {
        for (var item in eventMaps) {
          list.add(FollowEvent.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }

}