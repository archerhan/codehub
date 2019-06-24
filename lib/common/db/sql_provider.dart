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
  bool isTableExists = false;
  tableSqlString();
  tableName();

  tableBaseString(String name, String columnId){
    return '''
        create table $name (
        $columnId integer primary key autoincrement,
      ''';
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  @mustCallSuper
  open() async {
    if (!isTableExists) {
      await prepare(tableName(), tableSqlString());
    }
    return await DbManager.getCurrentDatabase();
  }

  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExists = await DbManager.isTableExits(name);
    if (!isTableExists) {
      Database db = await DbManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }
}
