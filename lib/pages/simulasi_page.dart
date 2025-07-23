import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/sensor_data.dart';
import '../providers/realtime_data_provider.dart';
import '../providers/simulasi_provider.dart';
import '../widgets/header.dart';
import 'laporan_page.dart';

class SimulasiPage extends StatelessWidget {
  final Function(String)? onMenuSelected;
  const SimulasiPage({super.key, this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    final realtimeProvider = Provider.of<RealtimeDataProvider>(context);
    final simulasiProvider = Provider.of<SimulasiProvider>(context);

    final latest = realtimeProvider.latestData;
    if (latest != null &&
        !simulasiProvider.containsTimestamp(latest.timestamp)) {
      simulasiProvider.addData(latest);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(title: 'Simulasi', onMenuSelected: onMenuSelected),
              const SizedBox(height: 16),
              _buildChart(realtimeProvider),
              const SizedBox(height: 20),
              _buildButtons(context, simulasiProvider),
              const SizedBox(height: 20),
              _buildScrollableTable(simulasiProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(RealtimeDataProvider provider) {
    final data = provider.history;
    if (data.isEmpty) return const Text("Belum ada data.");

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Grafik Suhu dan Kelembaban',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 260,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: data
                          .map((e) => FlSpot(
                              e.timestamp.millisecondsSinceEpoch.toDouble(),
                              e.temperature))
                          .toList(),
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 2,
                      belowBarData: BarAreaData(
                          show: true, color: Colors.orange.withOpacity(0.2)),
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: data
                          .map((e) => FlSpot(
                              e.timestamp.millisecondsSinceEpoch.toDouble(),
                              e.humidity))
                          .toList(),
                      isCurved: true,
                      color: Colors.lightBlue,
                      barWidth: 2,
                      belowBarData: BarAreaData(
                          show: true, color: Colors.lightBlue.withOpacity(0.2)),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, _) =>
                            Text('${value.toInt()}'),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: data.length > 6
                            ? (data.last.timestamp
                                        .difference(data.first.timestamp)
                                        .inMilliseconds ~/
                                    6)
                                .toDouble()
                            : 10000,
                        getTitlesWidget: (value, _) {
                          final date = DateTime.fromMillisecondsSinceEpoch(
                              value.toInt());
                          return Text(DateFormat.Hm().format(date),
                              style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(),
                      left: BorderSide(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.thermostat, size: 16, color: Colors.orange),
                SizedBox(width: 6),
                Text("Suhu"),
                SizedBox(width: 16),
                Icon(Icons.water_drop, size: 16, color: Colors.lightBlue),
                SizedBox(width: 6),
                Text("Kelembaban"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, SimulasiProvider provider) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const LaporanPage())),
          icon: const Icon(Icons.print),
          label: const Text("Cetak PDF"),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => provider.resetData(),
          icon: const Icon(Icons.refresh),
          label: const Text("Reset"),
        ),
      ],
    );
  }

  Widget _buildScrollableTable(SimulasiProvider provider) {
    final data = provider.data.reversed.toList();
    if (data.isEmpty) {
      return const Center(child: Text('Tidak ada data simulasi.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Hasil Simulasi Fuzzy",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 400, // Atur tinggi maksimal tabel
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                children: [
                  DataTable(
                    columnSpacing: 16,
                    headingRowColor: MaterialStateColor.resolveWith(
                        (_) => Colors.grey.shade200),
                    columns: const [
                      DataColumn(label: Text('Waktu')),
                      DataColumn(label: Text('Kelembaban')),
                      DataColumn(label: Text('Suhu')),
                      DataColumn(label: Text('Hasil')),
                      DataColumn(label: Text('Keterangan')),
                    ],
                    rows: data.take(10).map((e) {
                      return DataRow(cells: [
                        DataCell(Text(e.timestampFormatted)),
                        DataCell(Text('${e.humidity.toStringAsFixed(1)}%')),
                        DataCell(Text('${e.temperature.toStringAsFixed(1)}°C')),
                        DataCell(Text(e.duration.toStringAsFixed(1))),
                        DataCell(Text(e.keterangan)),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
