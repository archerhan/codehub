/**
 *  author : archer
 *  date : 2019-06-21 09:56
 *  description :
 */


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
}