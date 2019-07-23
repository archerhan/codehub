/**
 *  author : archer
 *  date : 2019-06-20 11:06
 *  description : 网络请求返回结果
 */

class ResultData {
  ResultData(this.data, this.result, this.code, {this.headers});

  var data;
  bool result;
  int code;
  var headers;
}
