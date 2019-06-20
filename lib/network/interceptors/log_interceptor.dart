
/**
 *  author : archer
 *  date : 2019-06-20 10:25
 *  description : Log拦截器
 */

import 'package:dio/dio.dart';
import 'package:codehub/common/constant/global_config.dart';

class LogsInterceptor extends InterceptorsWrapper {

  @override
  onRequest(RequestOptions options) {
    if (GlobalConfig.DEBUG) {
      print("请求url：${options.path}");
      print('请求头: ' + options.headers.toString());
      if (options.data != null) {
        print('请求参数: ' + options.data.toString());
      }
    }
    return options;
  }

  @override
  onResponse(Response response) {
    if (GlobalConfig.DEBUG) {
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }
    return response; // continue
  }

  @override
  onError(DioError err) {
    if (GlobalConfig.DEBUG) {
      print('请求异常: ' + err.toString());
      print('请求异常信息: ' + err.response?.toString() ?? "");
    }
    return err;
  }
}

