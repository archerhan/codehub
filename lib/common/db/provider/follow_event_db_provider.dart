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
  final String name = 'ReceivedEvent';

  final String columnId = "_id";
  final String columnData = "data";

  int id;
  String data;

  FollowEventReceivedDbProvider();

  Map<String, dynamic> toMap(String eventMapString) {
    Map<String, dynamic> map = {columnData: eventMapString};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  FollowEventReceivedDbProvider.fromMap(Map map) {
    id = map[columnId];
    data = map[columnData];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnData text not null)
      ''';
  }

  @override
  tableName() {
    return name;
  }

  ///插入到数据库
  Future insert(String eventMapString) async {
    Database db = await getDataBase();

    ///清空后再插入，因为只保存第一页面
    db.execute("delete from $name");
    return await db.insert(name, toMap(eventMapString));
  }

  ///获取事件数据
  Future<List<FollowEvent>> getEvents() async {
    Database db = await getDataBase();
    List<Map> maps = await db.query(name, columns: [columnId, columnData]);
    List<FollowEvent> list = new List();
    if (maps.length > 0) {
      FollowEventReceivedDbProvider provider =
          FollowEventReceivedDbProvider.fromMap(maps.first);

      ///使用 compute 的 Isolate 优化 json decode
      List<dynamic> eventMap =
          await compute(CodeUtils.decodeListResult, provider.data);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(FollowEvent.fromJson(item));
        }
      }
    }
    return list;
  }
}
