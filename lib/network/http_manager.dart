import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:codehub/network/interceptors/header_interceptor.dart';
import 'package:codehub/network/interceptors/response_interceptor.dart';
import 'package:codehub/network/interceptors/log_interceptor.dart';
import 'package:codehub/network/interceptors/token_interceptor.dart';
import 'package:codehub/network/interceptors/error_interceptor.dart';
import 'package:codehub/network/status_code.dart';
import 'package:codehub/network/result_data.dart';
import 'package:codehub/common/constant/global_config.dart';

class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  Dio _dio = Dio();

  // 设置代理用来调试应用

  final TokenInterceptor _tokenInterceptor = TokenInterceptor();

  HttpManager() {
    _dio.interceptors.add(new HeaderInterceptor());
    _dio.interceptors.add(_tokenInterceptor);
    _dio.interceptors.add(new LogsInterceptor());
    _dio.interceptors.add(new ResponseInterceptor());
    _dio.interceptors.add(new ErrorInterceptor(_dio));

    /// 用1个开关设置是否开启代理
    if (GlobalConfig.USE_PROXY) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          // return GlobalConfig.DEBUG ? GlobalConfig.PROXY_IP : 'DIRECT';
          return GlobalConfig.PROXY_IP;
        };
      };
    }
  }

  request(url, params, Map<String, dynamic> header, Options options,
      {noTip = false}) async {
    Map<String, dynamic> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }
    if (options != null) {
      options.headers = headers;
    } else {
      options = new Options(method: "get");
      options.headers = headers;
    }

    resultError(DioError e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = StatusCode.NETWORK_TIMEOUT;
      }
      return new ResultData(
          StatusCode.errorHandleFunction(
              errorResponse.statusCode, e.message, noTip),
          false,
          errorResponse.statusCode);
    }

    Response response;
    try {
      response = await _dio.request(url, data: params, options: options);
    } on DioError catch (e) {
      return resultError(e);
    }
    if (response.data is DioError) {
      return resultError(response.data);
    }
    return response.data;
  }

  ///清除授权
  clearAuthorization() {
    _tokenInterceptor.clearAuthorization();
  }

  ///获取授权token
  getAuthorization() async {
    return _tokenInterceptor.getAuthorization();
  }
}

final HttpManager httpManager = HttpManager();
