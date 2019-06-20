/**
 *  author : archer
 *  date : 2019-06-20 10:32
 *  description :
 */
import 'package:shared_preferences/shared_preferences.dart';
class LocalStorage {
  static save(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }
  static get(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.get(key);
  }
  static remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }
}


