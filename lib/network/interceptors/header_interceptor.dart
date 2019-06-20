/**
 *  author : archer
 *  date : 2019-06-20 10:24
 *  description : header拦截器
 */

import 'package:dio/dio.dart';

class HeaderInterceptor extends InterceptorsWrapper {

  @override
  onRequest(RequestOptions options) {
    //设置请求超时
    options.connectTimeout = 15000;
    return options;

  }
}
