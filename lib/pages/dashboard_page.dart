import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import '../providers/realtime_data_provider.dart';
import '../providers/device_status_provider.dart';
import '../widgets/header.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/confirmation_dialog.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? _pompaTimer;
  Timer? _onlineTimer;

  bool powerStatus = false;
  int _pompaDuration = 0;
  Duration _durasiOnline = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startOnlineTimer();
  }

  @override
  void dispose() {
    _pompaTimer?.cancel();
    _onlineTimer?.cancel();
    super.dispose();
  }

Future<void> _togglePompa(BuildContext context, bool isOn) async {
  if (isOn) {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: "Konfirmasi",
        message: "Apakah Anda yakin ingin menyalakan pompa?",
      ),
    );

    if (konfirmasi == true) {
      setState(() {
        powerStatus = true;
      });
      _startPompaTimer();
      FirebaseDatabase.instance.ref('data_sensor/relay').set(1);
    }
  } else {
    setState(() {
      powerStatus = false;
    });
    _stopPompaTimer();
    FirebaseDatabase.instance.ref('data_sensor/relay').set(0);
  }
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

  void _startOnlineTimer() {
    _onlineTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final deviceProvider = Provider.of<DeviceStatusProvider>(context, listen: false);
      final firstOnline = deviceProvider.firstOnline;

      if (firstOnline != "-") {
        final jamMenit = firstOnline.split(':');
        if (jamMenit.length == 2) {
          final int jam = int.tryParse(jamMenit[0]) ?? 0;
          final int menit = int.tryParse(jamMenit[1]) ?? 0;

          final now = DateTime.now();
          final waktuMulai = DateTime(now.year, now.month, now.day, jam, menit);

          setState(() {
            _durasiOnline = DateTime.now().difference(waktuMulai);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sensor = Provider.of<RealtimeDataProvider>(context);
    final device = Provider.of<DeviceStatusProvider>(context);

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
                _buildSensorRow(sensor),
                const SizedBox(height: 32),
                _buildDeviceStatus(device),
                const SizedBox(height: 32),
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

  Widget _buildSensorRow(RealtimeDataProvider sensor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSensorBox('Kelembaban Tanah', '${sensor.kelembaban.toStringAsFixed(1)} %', Icons.water_drop),
        _buildSensorBox('Suhu Udara', '${sensor.suhu.toStringAsFixed(1)} °C', Icons.thermostat),
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

  Widget _buildDeviceStatus(DeviceStatusProvider device) {
    final status = device.status;
    final isOnline = status == "ONLINE";

    final waktuOnline = "${_durasiOnline.inHours.toString().padLeft(2, '0')}:"
        "${(_durasiOnline.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(_durasiOnline.inSeconds % 60).toString().padLeft(2, '0')}";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isOnline ? Colors.green.shade50 : Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Perangkat: $status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isOnline ? Colors.green.shade800 : Colors.red.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text("Pertama Online: ${device.firstOnline}"),
            Text("Update Terakhir: ${device.lastUpdate}"),
            if (isOnline)
              Text("Waktu Online: $waktuOnline"),
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
              onPressed: () => _togglePompa(context, false),
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
              onPressed: () => _togglePompa(context, true),
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
