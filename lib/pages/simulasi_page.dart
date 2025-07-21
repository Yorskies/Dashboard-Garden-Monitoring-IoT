import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/realtime_data_provider.dart';
import '../widgets/header.dart';
import 'laporan_page.dart';

class SimulasiPage extends StatefulWidget {
  const SimulasiPage({Key? key}) : super(key: key);

  @override
  State<SimulasiPage> createState() => _SimulasiPageState();
}

class _SimulasiPageState extends State<SimulasiPage> {
  final List<Map<String, String>> _simulasiData = [];
  Timer? _timer;
  DateTime? _lastResetDate;

  @override
  void initState() {
    super.initState();
    _lastResetDate = DateTime.now();
    _startFuzzyTimer();
  }

  void _startFuzzyTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      final provider = Provider.of<RealtimeDataProvider>(context, listen: false);
      final kelembaban = provider.kelembaban;
      final suhu = provider.suhu;

      if (kelembaban != null && suhu != null) {
        final hasil = _prosesFuzzy(kelembaban, suhu);
        final now = DateFormat('HH:mm').format(DateTime.now());

        setState(() {
          if (_shouldReset()) {
            _simulasiData.clear();
            _lastResetDate = DateTime.now();
          }
          _simulasiData.add({
            'waktu': now,
            'kelembaban': '${kelembaban.toStringAsFixed(1)}%',
            'suhu': '${suhu.toStringAsFixed(1)}°C',
            'hasil': hasil['output']!,
            'keterangan': hasil['keterangan']!,
          });
          if (_simulasiData.length > 100) {
            _simulasiData.removeAt(0);
          }
        });
      }
    });
  }

  bool _shouldReset() {
    final now = DateTime.now();
    return _lastResetDate != null &&
        (now.day != _lastResetDate!.day ||
            now.month != _lastResetDate!.month ||
            now.year != _lastResetDate!.year);
  }

  Map<String, String> _prosesFuzzy(double kelembaban, double suhu) {
    double fuzzyMembership(double x, double a, double b, double c) {
      if (x <= a || x >= c) return 0;
      if (x == b) return 1;
      if (x < b) return (x - a) / (b - a);
      return (c - x) / (c - b);
    }

    double tanahKering = fuzzyMembership(kelembaban, 0, 30, 60);
    double tanahNormal = fuzzyMembership(kelembaban, 55, 67.5, 80);
    double tanahBasah = fuzzyMembership(kelembaban, 80, 90, 100);

    double suhuPanas = fuzzyMembership(suhu, 25, 30, 35);
    double suhuSedang = fuzzyMembership(suhu, 15, 22.5, 30);
    double suhuDingin = fuzzyMembership(suhu, 0, 10, 20);

    double w1 = tanahKering < suhuPanas ? tanahKering : suhuPanas;
    double z1 = 10;
    double w2 = tanahNormal < suhuSedang ? tanahNormal : suhuSedang;
    double z2 = 3;
    double w3 = tanahBasah < suhuDingin ? tanahBasah : suhuDingin;
    double z3 = 0;

    double numerator = (w1 * z1) + (w2 * z2) + (w3 * z3);
    double denominator = (w1 + w2 + w3);
    double output = (denominator == 0) ? 0 : (numerator / denominator);

    return {
      'output': output.toStringAsFixed(1),
      'keterangan': output == 0 ? 'Tidak disiram' : 'Disiram ${output.toStringAsFixed(1)} detik',
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RealtimeDataProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(title: 'Simulasi'),
            const SizedBox(height: 16),
            _buildChart(provider),
            const SizedBox(height: 16),
            _buildButtons(context),
            const SizedBox(height: 16),
            _buildTable(),
          ],
        ),
      ),
    );
  }

Widget _buildChart(RealtimeDataProvider provider) {
  final data = provider.history;
  if (data.isEmpty) return const Text("Belum ada data.");

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Suhu & Kelembaban',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: data.map((e) => FlSpot(
                      e.timestamp.millisecondsSinceEpoch.toDouble(),
                      e.temperature,
                    )).toList(),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: data.map((e) => FlSpot(
                      e.timestamp.millisecondsSinceEpoch.toDouble(),
                      e.humidity,
                    )).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 40,
                      getTitlesWidget: (value, _) => Text('${value.toInt()}'),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: data.length >= 6
                          ? (data.last.timestamp
                                  .difference(data.first.timestamp)
                                  .inMilliseconds ~/ 5)
                                  .toDouble()
                          : 10000,
                      getTitlesWidget: (value, _) {
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        final formatted = DateFormat.Hm().format(date);
                        return Text(formatted, style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(),
                    bottom: BorderSide(),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.grey.shade800,
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final date = DateFormat.Hm().format(
                            DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()));
                        return LineTooltipItem(
                          '${spot.bar.color == Colors.red ? 'Suhu' : 'Kelembaban'}\n'
                          '$date\n${spot.y.toStringAsFixed(1)}',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.thermostat, color: Colors.red, size: 14),
              SizedBox(width: 4),
              Text("Suhu"),
              SizedBox(width: 12),
              Icon(Icons.water_drop, color: Colors.blue, size: 14),
              SizedBox(width: 4),
              Text("Kelembaban"),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LaporanPage()));
          },
          icon: const Icon(Icons.print),
          label: const Text('Cetak'),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () {
            setState(() => _simulasiData.clear());
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hasil Simulasi Fuzzy',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: 12,
                columns: const [
                  DataColumn(label: Text('Waktu')),
                  DataColumn(label: Text('Kelembaban')),
                  DataColumn(label: Text('Suhu')),
                  DataColumn(label: Text('Hasil')),
                  DataColumn(label: Text('Keterangan')),
                ],
                rows: _simulasiData
                    .reversed
                    .take(10)
                    .map(
                      (data) => DataRow(cells: [
                        DataCell(Text(data['waktu']!)),
                        DataCell(Text(data['kelembaban']!)),
                        DataCell(Text(data['suhu']!)),
                        DataCell(Text(data['hasil']!)),
                        DataCell(Text(data['keterangan']!)),
                      ]),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
