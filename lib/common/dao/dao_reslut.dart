/**
 *  author : archer
 *  date : 2019-06-21 10:16
 *  description :
 */
import 'dart:async';

class DataResult {
  DataResult(this.data, this.result, {this.next});
  var data;
  bool result;
  Future next;
}
