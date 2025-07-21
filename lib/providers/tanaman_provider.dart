import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';

class TanamanProvider extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('tanaman');

  List<Map<String, dynamic>> _daftarTanaman = [];
  List<String> _keys = [];

  List<Map<String, dynamic>> get daftarTanaman => _daftarTanaman;

  TanamanProvider() {
    _ambilDataDariFirebase();
  }

  void _ambilDataDariFirebase() {
    _database.onValue.listen((event) {
      final snapshot = event.snapshot;
      final data = snapshot.value as Map?;

      if (data != null) {
        final List<Map<String, dynamic>> listBaru = [];
        final List<String> keysBaru = [];

        data.forEach((key, value) {
          if (value is Map) {
            final mapData = Map<String, dynamic>.from(value);

            // Buang field 'gambar' jika tidak diperlukan
            mapData.remove('gambar');

            listBaru.add(mapData);
            keysBaru.add(key);
          }
        });

        _daftarTanaman = listBaru;
        _keys = keysBaru;
        notifyListeners();
      }
    });
  }

  Future<void> addTanaman(Map<String, String> tanamanBaru) async {
    final data = Map<String, String>.from(tanamanBaru);
    data.remove('gambar'); // hilangkan field gambar sebelum dikirim
    await _database.push().set(data);
  }

  Future<void> updateTanaman(int index, Map<String, String> dataUpdate) async {
    if (index >= 0 && index < _keys.length) {
      final key = _keys[index];
      final data = Map<String, String>.from(dataUpdate);
      data.remove('gambar'); // hilangkan field gambar
      await _database.child(key).update(data);
    }
  }

  Future<void> deleteTanaman(int index) async {
    if (index >= 0 && index < _keys.length) {
      final key = _keys[index];
      await _database.child(key).remove();
    }
  }

  String? getKey(int index) {
    if (index >= 0 && index < _keys.length) {
      return _keys[index];
    }
    return null;
  }
}
