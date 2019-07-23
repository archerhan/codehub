/**
 *  author : archer
 *  date : 2019-06-22 22:52
 *  description : 数据库管理
 */

import 'dart:async';
import 'dart:io';

import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  static const _VERSION = 1;

  static const _NAME = "codehub_flutter.db";

  static Database _database;

  ///初始化
  static init() async {
    //打开log
    Sqflite.setDebugModeOn(true);
    // open the database
    var databasesPath = await getDatabasesPath();
    var userRes = await UserDao.getUserInLocal();
    String dbName = _NAME;
    if (userRes != null && userRes.result) {
      User user = userRes.data;
      if (user != null && user.login != null) {
        dbName = user.login + "_" + _NAME;
      }
    }
    String path = databasesPath + dbName;
    if (Platform.isIOS) {
      path = databasesPath + "/" + dbName;
    }
    _database = await openDatabase(path, version: _VERSION,
        onCreate: (Database db, int version) async {
      print("数据库创建成功PATH=$path");
      // When creating the db, create the table
      //await db.execute("CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
    });
  }

  ///表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  ///获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  ///关闭
  static close() {
    _database?.close();
    _database = null;
  }
}
