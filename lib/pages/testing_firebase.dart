import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TestingFirebasePage extends StatelessWidget {
  const TestingFirebasePage({Key? key}) : super(key: key);

  void _kirimDataUjiCoba(BuildContext context) async {
    final ref = FirebaseDatabase.instance.ref();
    final timestamp = DateTime.now().toIso8601String();

    try {
      await ref.child('pengujian_flutter_web').set({
        'waktu': timestamp,
        'status': 'berhasil',
        'sumber': 'flutter_web'
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Data berhasil dikirim ke Firebase')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal mengirim data: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tes Firebase Realtime Database')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _kirimDataUjiCoba(context),
          icon: const Icon(Icons.send),
          label: const Text('Kirim Data Uji'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ),
    );
  }
}
