/**
 *  author : archer
 *  date : 2019-06-23 10:57
 *  description :
 */

import 'dart:convert';

class CodeUtils {

  static List<dynamic> decodeListResult(String data) {
    return json.decode(data);
  }

  static Map<String, dynamic> decodeMapResult(String data) {
    return json.decode(data);
  }

  static String encodeToString(String data) {
    return json.encode(data);
  }

}