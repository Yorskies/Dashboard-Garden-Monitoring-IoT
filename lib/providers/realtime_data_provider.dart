import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDataProvider extends ChangeNotifier {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("data_sensor");

  double _suhu = 0;
  double _kelembaban = 0;
  double _durasi = 0;
  String _waktu = "-";
  int _relay = 0;

  double get suhu => _suhu;
  double get kelembaban => _kelembaban;
  double get durasi => _durasi;
  String get waktu => _waktu;
  int get relay => _relay;

  RealtimeDataProvider() {
    _startListening();
  }

  void _startListening() {
    _ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        _suhu = (data['suhu'] ?? 0).toDouble();
        _kelembaban = (data['kelembaban'] ?? 0).toDouble();
        _durasi = (data['durasi'] ?? 0).toDouble();
        _waktu = (data['waktu'] ?? "-").toString();
        _relay = int.tryParse(data['relay'].toString()) ?? 0;

        notifyListeners(); // 🚨 Update semua listener
      }
    });
  }
}
