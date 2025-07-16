import 'package:flutter/material.dart';
import '../widgets/header.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double kelembabanTanah = 56.5;
  double suhuUdara = 29.3;
  bool powerStatus = false;
  Timer? _pompaTimer;
  int _pompaDuration = 0; // dalam detik

  @override
  void dispose() {
    _pompaTimer?.cancel();
    super.dispose();
  }

  void _togglePompa(bool isOn) {
    setState(() {
      powerStatus = isOn;
      if (isOn) {
        _startPompaTimer();
      } else {
        _stopPompaTimer();
      }
    });
  }

  void _startPompaTimer() {
    _pompaTimer?.cancel();
    _pompaDuration = 0;
    _pompaTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _pompaDuration++;
      });
    });
  }

  void _stopPompaTimer() {
    _pompaTimer?.cancel();
    _pompaDuration = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(title: 'Dashboard'),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSensorRow(),
                const SizedBox(height: 40),
                _buildPompaControl(),
                const SizedBox(height: 24),
                _buildStatusPompa(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSensorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSensorBox('Kelembaban Tanah', '${kelembabanTanah.toStringAsFixed(1)} %', Icons.water_drop),
        _buildSensorBox('Suhu Udara', '${suhuUdara.toStringAsFixed(1)} °C', Icons.thermostat),
      ],
    );
  }

  Widget _buildSensorBox(String label, String value, IconData icon) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 250,
        height: 130,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green.shade800, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 22, color: Colors.green.shade900)),
          ],
        ),
      ),
    );
  }

  Widget _buildPompaControl() {
    return Column(
      children: [
        const Text(
          'Kontrol Pompa Manual',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _togglePompa(false),
              icon: const Icon(Icons.power_settings_new),
              label: const Text('Power OFF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: () => _togglePompa(true),
              icon: const Icon(Icons.flash_on),
              label: const Text('Power ON'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusPompa() {
    return Center(
      child: Column(
        children: [
          Text(
            'Status Pompa: ${powerStatus ? "MENYALA" : "MATI"}',
            style: TextStyle(
              fontSize: 16,
              color: powerStatus ? Colors.green.shade800 : Colors.red.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (powerStatus)
            Text(
              'Waktu berjalan: $_pompaDuration detik',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
        ],
      ),
    );
  }
}
