// lib/services/simulasi_storage.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sensor_data.dart';

class SimulasiStorage {
  static const String _key = 'simulasi_data';

  static Future<void> save(List<SensorData> dataList) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = dataList.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(encodedData));
  }

  static Future<List<SensorData>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final rawString = prefs.getString(_key);
    if (rawString == null) return [];
    final List<dynamic> decoded = jsonDecode(rawString);
    return decoded.map((e) => SensorData.fromJson(e)).toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
