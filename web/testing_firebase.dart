import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert'; // untuk utf8.encode
import 'package:crypto/crypto.dart'; // untuk sha256

class TestingFirebasePage extends StatelessWidget {
  const TestingFirebasePage({Key? key}) : super(key: key);

  // Fungsi hashing password dengan SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _kirimDataUser(BuildContext context) async {
    final ref = FirebaseDatabase.instance.ref();
    final userRef = ref.child('user');

    final username = 'admin';
    final rawPassword = 'admin123';
    final hashedPassword = hashPassword(rawPassword);

    try {
      // Simpan data user dengan username sebagai key dan password yang di-hash
      await userRef.child(username).set({
        'username': username,
        'password': hashedPassword,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Data user berhasil dikirim ke Firebase')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal mengirim data user: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tes Simpan Data User')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _kirimDataUser(context),
          icon: const Icon(Icons.person_add),
          label: const Text('Simpan User'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ),
    );
  }
}
