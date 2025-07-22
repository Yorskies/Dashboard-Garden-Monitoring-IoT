import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sensor_data.dart';

class SimulasiProvider extends ChangeNotifier {
  final List<SensorData> _data = [];
  Timer? _timer;
  DateTime? _lastResetDate;

  List<SensorData> get data => _data;

  SimulasiProvider() {
    _lastResetDate = DateTime.now();
    _loadStoredData();
    _startSimulation();
  }

  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('simulasi_data');
    if (raw == null) return;

    final List<dynamic> decoded = jsonDecode(raw);
    _data.clear();
    _data.addAll(decoded.map((e) => SensorData.fromJson(e)));
    notifyListeners();
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      final now = DateTime.now();
      final suhu = 28.0 + (5 * (0.5 - (now.second % 10) / 10));
      final kelembaban = 70.0 + (10 * (0.5 - (now.second % 10) / 10));

      final hasil = _prosesFuzzy(kelembaban, suhu);
      final dataBaru = SensorData(
        timestamp: now,
        temperature: suhu,
        humidity: kelembaban,
        duration: hasil['output'],
        keterangan: hasil['keterangan'],
      );

      if (_shouldReset()) {
        _data.clear();
        _lastResetDate = now;
      }

      _data.add(dataBaru);
      if (_data.length > 100) {
        _data.removeAt(0);
      }

      _saveToPrefs();
      notifyListeners();
    });
  }

  bool _shouldReset() {
    final now = DateTime.now();
    return _lastResetDate != null &&
        (now.day != _lastResetDate!.day ||
         now.month != _lastResetDate!.month ||
         now.year != _lastResetDate!.year);
  }

  Map<String, dynamic> _prosesFuzzy(double kelembaban, double suhu) {
    double fuzzyMembership(double x, double a, double b, double c) {
      if (x <= a || x >= c) return 0;
      if (x == b) return 1;
      if (x < b) return (x - a) / (b - a);
      return (c - x) / (c - b);
    }

    double tanahKering = fuzzyMembership(kelembaban, 0, 30, 60);
    double tanahNormal = fuzzyMembership(kelembaban, 55, 67.5, 80);
    double tanahBasah = fuzzyMembership(kelembaban, 80, 90, 100);

    double suhuPanas = fuzzyMembership(suhu, 25, 30, 35);
    double suhuSedang = fuzzyMembership(suhu, 15, 22.5, 30);
    double suhuDingin = fuzzyMembership(suhu, 0, 10, 20);

    double w1 = tanahKering < suhuPanas ? tanahKering : suhuPanas;
    double z1 = 10;
    double w2 = tanahNormal < suhuSedang ? tanahNormal : suhuSedang;
    double z2 = 3;
    double w3 = tanahBasah < suhuDingin ? tanahBasah : suhuDingin;
    double z3 = 0;

    double numerator = (w1 * z1) + (w2 * z2) + (w3 * z3);
    double denominator = (w1 + w2 + w3);
    double output = (denominator == 0) ? 0 : (numerator / denominator);

    return {
      'output': output,
      'keterangan': output == 0 ? 'Tidak disiram' : 'Disiram ${output.toStringAsFixed(1)} detik',
    };
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = _data.map((e) => e.toJson()).toList(); // ✅ Gunakan toJson asli
    await prefs.setString('simulasi_data', jsonEncode(jsonData));
  }

  void resetData() async {
    _data.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('simulasi_data');
  }

  bool containsTimestamp(DateTime timestamp) {
    return _data.any((item) => item.timestamp == timestamp);
  }

  void addData(SensorData dataBaru) {
    if (!containsTimestamp(dataBaru.timestamp)) {
      _data.add(dataBaru);
      if (_data.length > 100) {
        _data.removeAt(0);
      }
      _saveToPrefs();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
