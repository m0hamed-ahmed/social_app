import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({String key, dynamic value}) async {
    if(value.runtimeType == String) {return await sharedPreferences.setString(key, value);}
    if(value.runtimeType == bool) {return await sharedPreferences.setBool(key, value);}
    if(value.runtimeType == int) {return await sharedPreferences.setInt(key, value);}
    return await sharedPreferences.setDouble(key, value);
  }

  static dynamic getData({String key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> removeData({String key}) async {
    return await sharedPreferences.remove(key);
  }
}