import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    if (kIsWeb) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await secureStorage.write(key: key, value: value);
    }
  }

  Future<String?> read(String key) async {
    if (kIsWeb) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return await secureStorage.read(key: key);
    }
  }

  Future<void> delete(String key) async {
    if (kIsWeb) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } else {
      await secureStorage.delete(key: key);
    }
  }

  Future<void> deleteAll() async {
    if (kIsWeb) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } else {
      await secureStorage.deleteAll();
    }
  }
}
