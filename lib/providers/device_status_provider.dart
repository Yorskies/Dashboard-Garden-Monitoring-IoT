import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceStatusProvider extends ChangeNotifier {
  final DatabaseReference _ref =
      FirebaseDatabase.instance.ref("device_status/penyiraman_01");

  String _status = "UNKNOWN";
  String _lastUpdate = "-";
  String _firstOnline = "-";

  String get status => _status;
  String get lastUpdate => _lastUpdate;
  String get firstOnline => _firstOnline;

  DeviceStatusProvider() {
    _startListening();
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
}
