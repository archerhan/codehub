/**
 *  author : archer
 *  date : 2019-06-22 22:53
 *  description : 数据库表
 */

import 'dart:async';
import 'package:codehub/common/db/sql_manager.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDbProvider {
  bool isTableExits = false;

  tableSqlString();

  tableName();

  tableBaseString(String name, String columnId) {
    return '''
        create table $name (
        $columnId integer primary key autoincrement,
      ''';
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await DbManager.isTableExits(name);
    if (!isTableExits) {
      Database db = await DbManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(tableName(), tableSqlString());
    }
    return await DbManager.getCurrentDatabase();
  }
}
