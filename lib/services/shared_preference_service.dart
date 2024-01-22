import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Class khusus buat sharedpreferences 
biar terpusat ajah
*/

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _preferences;

  SharedPreferencesService._();

  //inisiasi sharedpreference
  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();
    _preferences = await SharedPreferences.getInstance();

    return _instance!;
  }

  //method untuk ambil data dari shared preferences
  dynamic getData(String key) {
    //ambil data
    var value = _preferences.get(key);

    //kalau debug, print hasilnya ke console
    if (kDebugMode) {
      print('Retrieved $key: $value');
    }

    return value;
  }

  //method untuk set data ke shared preferences
  dynamic saveData(String key, dynamic value) {
    if (kDebugMode) {
      print('Saving $key: $value');
    }

    if (value is String) {
      _preferences.setString(key, value);
    } else if (value is int) {
      _preferences.setInt(key, value);
    } else if (value is double) {
      _preferences.setDouble(key, value);
    } else if (value is bool) {
      _preferences.setBool(key, value);
    } else if (value is List<String>) {
      _preferences.setStringList(key, value);
    }
  }

  //method hapus data dari shared preferences
  dynamic deleteData(String key) {
    if (kDebugMode) {
      print('Deleting $key');
    }

    _preferences.remove(key);
  }
}
