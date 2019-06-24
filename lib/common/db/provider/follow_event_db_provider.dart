/**
 *  author : archer
 *  date : 2019-06-24 20:55
 *  description :
 */

import 'dart:async';
import 'package:codehub/common/db/sql_provider.dart';
import 'package:codehub/common/model/follow_event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:codehub/common/utils/code_utils.dart';
import 'package:flutter/foundation.dart';

class FollowEventReceivedDbProvider extends BaseDbProvider {
  final String name = 'FollowEventReceivedDbProvider';//表名
  final String columnId = '_id';//id key
  final String columnData = 'data';// data key

  int id;
  String data;

  FollowEventReceivedDbProvider();


  Map<String, dynamic> toMap(String eventMapString){
    Map<String, dynamic> map = {columnData : eventMapString};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  FollowEventReceivedDbProvider.fromMap(Map map){
    id = map[columnId];
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
    $columnData text not null
    ''';
  }
  ///插入数据
  Future insert(String eventMapString) async {
    Database db = await getDataBase();
    db.execute("delete from $name");//删除老数据
    return await db.insert(name, toMap(eventMapString));
  }
  ///查数据
  Future<List<FollowEvent>> getFollowEvents() async {
    Database db = await getDataBase();
    List<Map> maps = await db.query(name, columns: [columnId, columnData]);
    List<FollowEvent> list = List();
    if (maps.length > 0) {
      FollowEventReceivedDbProvider provider = FollowEventReceivedDbProvider.fromMap(maps.first);
      List<dynamic> eventMap = await compute(CodeUtils.decodeListResult, provider.data);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(FollowEvent.fromJson(item));
        }
      }
    }
    return list;
  }

}