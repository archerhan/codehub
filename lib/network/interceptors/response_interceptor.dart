/**
 *  author : archer
 *  date : 2019-06-20 10:25
 *  description :
 */

import 'package:dio/dio.dart';
import 'package:codehub/network/status_code.dart';
import 'package:codehub/network/result_data.dart';

class ResponseInterceptor extends InterceptorsWrapper {
  @override
  onResponse(Response response) {
    RequestOptions options = response.request;
    try {
      if (options.contentType != null &&
          options.contentType.primaryType == "text") {
        return ResultData(response.data, true, StatusCode.SUCCESS);
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResultData(response.data, true, StatusCode.SUCCESS,
            headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + options.path);
      return ResultData(response.data, false, response.statusCode,
          headers: response.headers);
    }
    return super.onResponse(response);
  }
}
