/**
 *  author : archer
 *  date : 2019-06-20 10:24
 *  description : token拦截器
 */
import 'package:dio/dio.dart';
import 'package:codehub/common/constant/global_config.dart';
import 'package:codehub/common/local/local_storage.dart';

class TokenInterceptor extends InterceptorsWrapper {
  String _token;

  @override
  //在请求头中添加授权码
  onRequest(RequestOptions options) async {
    if (_token == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        _token = authorizationCode;
      }
    }
    options.headers["Authorization"] = _token;
    return options;
  }

  @override
  //在返回结果中保存授权码
  onResponse(Response response) async{
    try {
      var responseJson = response.data;
      if (response.statusCode == 201 && responseJson["token"] != null) {
        _token = 'token ' + responseJson["token"];
        await LocalStorage.save(GlobalConfig.USER_TOKEN_KEY, _token);
      }
    } catch (e) {
      print(e);
    }
    return response;
  }

  clearAuthorization() {
    this._token = null;
    LocalStorage.remove(GlobalConfig.USER_TOKEN_KEY);
  }

  //获取授权
  getAuthorization() async {
    String token = await LocalStorage.get(GlobalConfig.USER_TOKEN_KEY);
    if (token == null) {
      String basic = await LocalStorage.get(GlobalConfig.USER_BASIC_CODE_KEY);
      if (basic == null) {
        print("请输入用户名或密码");
      }
      else {
        return "Basic $basic";
      }
    }
    else {
      this._token = token;
      return token;
    }
  }
}
