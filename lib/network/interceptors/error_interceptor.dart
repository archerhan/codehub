/**
 *  author : archer
 *  date : 2019-06-20 10:24
 *  description :
 */

import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:codehub/network/result_data.dart';
import 'package:codehub/network/status_code.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  final Dio _dio;
  ErrorInterceptor(this._dio);

  @override
  onRequest(RequestOptions options) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return _dio.resolve(ResultData(
          StatusCode.errorHandleFunction(StatusCode.NETWORK_ERROR, "", false),
          false,
          StatusCode.NETWORK_ERROR));
    }
    return options;
  }
}
