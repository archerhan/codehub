/**
 *  author : archer
 *  date : 2019-06-20 11:09
 *  description :
 */

import 'package:flutter/material.dart';

class HttpErrorEvent {
  final int code;

  final String message;

  HttpErrorEvent(this.code, this.message);
}