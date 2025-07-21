import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceStatusProvider extends ChangeNotifier {
  final DatabaseReference _ref =
      FirebaseDatabase.instance.ref("device_status/penyiraman_01");

  String _status = "UNKNOWN";
  String _lastUpdate = "-";
  String _firstOnline = "-";

  Timer? _checkTimer;

  String get status => _status;
  String get lastUpdate => _lastUpdate;
  String get firstOnline => _firstOnline;

  DeviceStatusProvider() {
    _startListening();
    _startAutoOfflineCheck();
  }

  void _startListening() {
    _ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        _status = data["status"]?.toString() ?? "UNKNOWN";
        _lastUpdate = data["last_update"]?.toString() ?? "-";
        _firstOnline = data["first_online"]?.toString() ?? "-";
        notifyListeners();
      }
    });
  }

  void _startAutoOfflineCheck() {
    _checkTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_status == "ONLINE" && _lastUpdate != "-") {
        try {
          final now = DateTime.now();
          final parts = _lastUpdate.split(':');
          if (parts.length == 2) {
            final jam = int.tryParse(parts[0]) ?? 0;
            final menit = int.tryParse(parts[1]) ?? 0;
            final last = DateTime(now.year, now.month, now.day, jam, menit);

            final selisih = now.difference(last);
            if (selisih.inSeconds > 30) {
              _status = "OFFLINE";
              notifyListeners();
            }
          }
        } catch (e) {
          print("Gagal parsing last_update: $e");
        }
      }
    });
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }
}
