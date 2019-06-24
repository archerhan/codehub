/**
 *  author : archer
 *  date : 2019-06-22 22:52
 *  description : 数据库管理
 */

import 'dart:async';
import 'dart:io';

import 'package:codehub/common/model/user.dart';
import 'package:codehub/common/dao/user_dao.dart';
import 'package:codehub/common/dao/dao_reslut.dart';

import 'package:sqflite/sqflite.dart';

class DbManager {
  static const _VERSION = 1;
  static const _NAME = "codehub_flutter.db";
  static Database _database;


  static init() async {
    String databasePath = await getDatabasesPath();
    DataResult userRes = await UserDao.getUserInLocal();

    String dbName = _NAME;

    if (userRes != null && userRes.result) {
      User user = userRes.data;
        if (user != null && user.login != null) {
          dbName = user.login + "_" + _NAME;
        }
    }

    String path = databasePath + dbName;
    if (Platform.isIOS) {
      path = databasePath + "/" + dbName;
    }

    _database = await openDatabase(path, version: _VERSION, onCreate: (Database db, int version) async{
      print("数据库创建成功PATH=$path");
    });
  }


  /**
   * 表是否存在
   */
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery("select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }


  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  static close() {
    _database?.close();
    _database = null;
  }
}

