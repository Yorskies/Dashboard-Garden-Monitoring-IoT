import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../widgets/header.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({Key? key}) : super(key: key);

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(title: 'Laporan'),
          const SizedBox(height: 24),

          // Kop surat
          Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 80,
                height: 80,
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'UNIVERSITAS CONTOH\nJl. Pendidikan No. 1, Kota Edukasi\nTelp: (021) 12345678',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),

          const Divider(height: 32, thickness: 2),

          const Text(
            'Laporan Simulasi Penyiraman Fuzzy',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          _buildTable(),

          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _cetakPDF(),
            icon: const Icon(Icons.print),
            label: const Text('Cetak PDF'),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Table(
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
    );
  }

  Future<void> _cetakPDF() async {
    final pdf = pw.Document();

    // Load logo
    final ByteData bytes = await rootBundle.load('assets/images/logo.png');
    final Uint8List logoBytes = bytes.buffer.asUint8List();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(
                pw.MemoryImage(logoBytes),
                width: 60,
                height: 60,
              ),
              pw.SizedBox(width: 16),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('UNIVERSITAS CONTOH',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Jl. Pendidikan No. 1, Kota Edukasi'),
                  pw.Text('Telp: (021) 12345678'),
                ],
              ),
            ],
          ),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 16),
          pw.Text('Laporan Simulasi Penyiraman Fuzzy',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          pw.Table.fromTextArray(
            headers: ['Waktu', 'Kelembaban', 'Suhu', 'Hasil', 'Keterangan'],
            data: dataSimulasi.map((row) => [
              row['waktu'],
              row['kelembaban'],
              row['suhu'],
              row['hasil'],
              row['keterangan'],
            ]).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
