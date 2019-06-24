/**
 *  author : archer
 *  date : 2019-06-21 09:56
 *  description :
 */

import 'package:codehub/common/constant/global_config.dart';

class Api {
  static const String host = "https://api.github.com/";
  static const String hostWeb = "https://github.com/";


  static getAuthorization() {
    return "${host}authorizations";
  }
  ///获取自己的信息
  static getMyUserInfo() {
    return "${host}user";
  }
  ///获取其他用户的信息
  static getUserInfo(username) {
    return "${host}users/$username";
  }
  ///用户的star get
  static userStar(userName, sort) {
    sort ??= 'updated';
    return "${host}users/$userName/starred?sort=$sort";
  }
  ///用户的仓库 get
  static userRepos(userName, sort) {
    sort ??= 'pushed';
    return "${host}users/$userName/repos?sort=$sort";
  }

  ///用户收到的事件信息 get
  static getEventReceived(userName) {
    return "${host}users/$userName/received_events";
  }

  ///用户相关的事件信息 get
  static getEvent(userName) {
    return "${host}users/$userName/events";
  }

  ///处理分页参数
  static getPageParams(tab, page, [pageSize = GlobalConfig.PAGE_SIZE]) {
    if (page != null) {
      if (pageSize != null) {
        return "${tab}page=$page&per_page=$pageSize";
      } else {
        return "${tab}page=$page";
      }
    } else {
      return "";
    }
  }

























}