///  author : archer
///  date : 2019-06-19 22:04
///  description : 全局常量, 包括字符串, 数字等

///
class GlobalConfig {


  //是否开启Log
  static const DEBUG = true;
  //开启代理, 上线前一定要关闭!!!!!!!
  static const USE_PROXY = true;
  static const PROXY_IP = "PROXY 192.168.1.96:8888";

  //分页
  static const PAGE_SIZE = 20;

  static const USER_TOKEN_KEY = "user-token-key";
  static const USER_ACCOUNT_KEY = "user-account-key";
  static const USER_PWD_KEY = "user-pwd-key";
  static const USER_BASIC_CODE_KEY = "user-basic-code-key";
  static const USER_INFO  = "user-info-key";

  static const CLIENT_ID = "这个不要对外暴露";
  static const CLIENT_SECRET = "这个不要对外暴露";

}
