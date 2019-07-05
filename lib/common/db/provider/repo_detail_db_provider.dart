/**
 *  author : archer
 *  date : 2019-07-05 11:12
 *  description :
 */

import 'package:codehub/common/utils/code_utils.dart';
import 'package:codehub/common/db/sql_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:codehub/common/model/repository.dart';
import 'package:flutter/foundation.dart';


class RepoDetailDbProvider extends BaseDbProvider {
  final name = "RepoDetail";
  final columnId = "_id";
  final columnFullName = "fullName";
  final columnData = "data";

  int id;
  String fullName;
  String data;

  RepoDetailDbProvider();

  Map<String, dynamic> toMap(String fullName, String dataMapString){
    Map<String, dynamic> map = {columnFullName : fullName, columnData : data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepoDetailDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
  }

  //有值才返回provider
  Future _getProvider(Database db,String fullName) async {
    db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name, columns: [columnId, columnFullName, columnData],where: "$columnFullName = ?", whereArgs: [fullName]);
    if (maps.length > 0) {
      RepoDetailDbProvider provider = RepoDetailDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
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

  Future insertDetail(String fullName, String dataMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      await db.delete(name, where: "$columnFullName = ?", whereArgs: [fullName]);
    }
    return await db.insert(name, toMap(fullName, dataMapString));
  }

  ///获取详情
  Future<Repository> getRepository(String fullName) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {


      ///使用 compute 的 Isolate 优化 json decode
      var mapData = await compute(CodeUtils.decodeMapResult, provider.data as String);

      return Repository.fromJson(mapData);
    }
    return null;
  }

}