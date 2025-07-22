import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/sensor_data.dart';

class RealtimeDataProvider extends ChangeNotifier {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("data_sensor");

  double _suhu = 0;
  double _kelembaban = 0;
  double _durasi = 0;
  String _waktu = "-";
  int _relay = 0;
  String _keterangan = "";
  List<SensorData> _sensorHistory = [];

  Timer? _timer;
  DateTime _lastResetDate = DateTime.now();

  // Getter publik
  double get suhu => _suhu;
  double get kelembaban => _kelembaban;
  double get durasi => _durasi;
  String get waktu => _waktu;
  int get relay => _relay;
  String get keterangan => _keterangan;
  List<SensorData> get history => _sensorHistory;

  // 🔧 Tambahan getter untuk latestData agar tidak error di simulasi_page
  SensorData? get latestData =>
      _sensorHistory.isNotEmpty ? _sensorHistory.last : null;

  RealtimeDataProvider() {
    _startListening();
    _startFuzzyCalculation();
  }

  void _startListening() {
    _ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        _suhu = (data['suhu'] ?? 0).toDouble();
        _kelembaban = (data['kelembaban'] ?? 0).toDouble();
        _waktu = (data['waktu'] ?? "-").toString();
        _relay = int.tryParse(data['relay'].toString()) ?? 0;
        notifyListeners();
      }
    });
  }

  void _startFuzzyCalculation() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkDailyReset();
      _hitungFuzzy();

      final dataBaru = SensorData(
        timestamp: DateTime.now(),
        temperature: _suhu,
        humidity: _kelembaban,
        duration: _durasi,
        keterangan: _keterangan,
      );

      _sensorHistory.add(dataBaru);
      if (_sensorHistory.length > 100) {
        _sensorHistory.removeAt(0);
      }

      notifyListeners();
    });
  }

  void _checkDailyReset() {
    final now = DateTime.now();
    if (now.day != _lastResetDate.day ||
        now.month != _lastResetDate.month ||
        now.year != _lastResetDate.year) {
      resetHistory();
      _lastResetDate = now;
    }
  }

  void resetHistory() {
    _sensorHistory.clear();
    notifyListeners();
  }

  void _hitungFuzzy() {
    double fuzzyMembership(double x, double a, double b, double c) {
      if (x <= a || x >= c) return 0;
      if (x == b) return 1;
      if (x < b) return (x - a) / (b - a);
      return (c - x) / (c - b);
    }

    double tanahKering = fuzzyMembership(_kelembaban, 0, 30, 60);
    double tanahNormal = fuzzyMembership(_kelembaban, 55, 67.5, 80);
    double tanahBasah = fuzzyMembership(_kelembaban, 80, 90, 100);

    double suhuPanas = fuzzyMembership(_suhu, 25, 30, 35);
    double suhuSedang = fuzzyMembership(_suhu, 15, 22.5, 30);
    double suhuDingin = fuzzyMembership(_suhu, 0, 10, 20);

    double w1 = tanahKering < suhuPanas ? tanahKering : suhuPanas;
    double z1 = 10;
    double w2 = tanahNormal < suhuSedang ? tanahNormal : suhuSedang;
    double z2 = 3;
    double w3 = tanahBasah < suhuDingin ? tanahBasah : suhuDingin;
    double z3 = 0;

    double numerator = (w1 * z1) + (w2 * z2) + (w3 * z3);
    double denominator = (w1 + w2 + w3);
    double output = (denominator == 0) ? 0 : (numerator / denominator);

    _durasi = output;
    _keterangan = output == 0
        ? 'Tidak disiram'
        : 'Disiram ${output.toStringAsFixed(1)} detik';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
