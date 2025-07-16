import 'package:flutter/material.dart';
import '../widgets/header.dart';

class SimulasiPage extends StatelessWidget {
  const SimulasiPage({Key? key}) : super(key: key);

  // Dummy data simulasi
  final List<Map<String, String>> dataSimulasi = const [
    {
      'waktu': '07:00',
      'kelembaban': '35%',
      'suhu': '30°C',
      'hasil': '7.5',
      'keterangan': 'Disiram 7.5 detik'
    },
    {
      'waktu': '17:00',
      'kelembaban': '60%',
      'suhu': '26°C',
      'hasil': '3.0',
      'keterangan': 'Disiram 3.0 detik'
    },
    {
      'waktu': '07:00',
      'kelembaban': '85%',
      'suhu': '20°C',
      'hasil': '0.0',
      'keterangan': 'Tidak disiram'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header(title: 'Simulasi'),
        const SizedBox(height: 24),
        _buildTable(),
      ],
    );
  }

  Widget _buildTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hasil Simulasi Fuzzy',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(1.2),
            3: FlexColumnWidth(1.2),
            4: FlexColumnWidth(2.0),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Colors.greenAccent),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Waktu', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Kelembaban', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Suhu', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Hasil', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Keterangan', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ...dataSimulasi.map((row) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(row['waktu']!),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(row['kelembaban']!),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(row['suhu']!),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(row['hasil']!),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(row['keterangan']!),
                ),
              ],
            )),
          ],
        ),
      ],
    );
  }
}
