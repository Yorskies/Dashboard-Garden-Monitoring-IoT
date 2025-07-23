import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _password = '';

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('user');

  // Getter
  String get username => _username;

  // Setter
  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  // Fungsi untuk hashing password dengan SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String getHashedPassword() {
    return hashPassword(_password);
  }

  // Simpan ke Firebase
  Future<void> saveUserToFirebase(BuildContext context) async {
    try {
      final hashedPassword = hashPassword(_password);

      await _dbRef.child(_username).set({
        'username': _username,
        'password': hashedPassword,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ User berhasil disimpan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal menyimpan user: $e')),
      );
    }
  }

  // Login function
  Future<bool> login(String inputUsername, String inputPassword) async {
    try {
      final snapshot = await _dbRef.child(inputUsername).get();

      if (!snapshot.exists) {
        return false; // Username tidak ditemukan
      }

      final data = snapshot.value as Map;
      final storedHashedPassword = data['password'] as String;

      final inputHashedPassword = hashPassword(inputPassword);

      if (inputHashedPassword == storedHashedPassword) {
        // Login sukses, simpan ke state
        _username = inputUsername;
        _password = inputPassword;
        notifyListeners();
        return true;
      } else {
        return false; // Password salah
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> updateUsername(BuildContext context, String newUsername) async {
    try {
      final oldUsername = _username;
      final hashedPassword = hashPassword(_password);

      // 1. Ambil data lama (opsional - bisa lewati jika hanya update field)
      final oldRef = _dbRef.child(oldUsername);
      final newRef = _dbRef.child(newUsername);

      final snapshot = await oldRef.get();
      if (!snapshot.exists) {
        throw 'Data lama tidak ditemukan';
      }

      final data = {
        'username': newUsername,
        'password': hashedPassword,
      };

      // 2. Simpan ke node baru
      await newRef.set(data);

      // 3. Hapus node lama
      await oldRef.remove();

      // 4. Update state lokal
      _username = newUsername;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Username berhasil diperbarui")),
      );

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Gagal memperbarui username: $e")),
      );
      return false;
    }
  }

  void resetUser() {
    _username = '';
    _password = '';
    notifyListeners();
  }

}
