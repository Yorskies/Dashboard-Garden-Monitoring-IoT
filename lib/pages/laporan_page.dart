import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../widgets/header.dart';
import '../models/sensor_data.dart';
import '../providers/simulasi_provider.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataSimulasi = context.watch<SimulasiProvider>().data;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(title: 'Laporan'),
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
                      'STMIK Pelita Nusantara\nJl. Iskandar Muda No.1, Merdeka, Kec. Medan Baru, Kota Medan, Sumatera Utara\nTelp: (061) 7952010',
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
              _buildTable(dataSimulasi),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _cetakPDF(dataSimulasi),
                icon: const Icon(Icons.print),
                label: const Text('Cetak PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(List<SensorData> dataSimulasi) {
    if (dataSimulasi.isEmpty) {
      return const Text("Tidak ada data simulasi.");
    }

    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
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
                  child: Text(row.timestampFormatted),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${row.humidity.toStringAsFixed(1)}%'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${row.temperature.toStringAsFixed(1)}°C'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${row.duration.toStringAsFixed(1)}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(row.keterangan),
                ),
              ],
            )),
      ],
    );
  }

  Future<void> _cetakPDF(List<SensorData> dataSimulasi) async {
    final pdf = pw.Document();

    final ByteData bytes = await rootBundle.load('assets/images/logo.png');
    final Uint8List logoBytes = bytes.buffer.asUint8List();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(pw.MemoryImage(logoBytes), width: 60, height: 60),
              pw.SizedBox(width: 16),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('STMIK Pelita Nusantara',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Jl. Iskandar Muda No.1, Medan Baru, Kota Medan, Sumatera Utara'),
                  pw.Text('Telp: (061) 7952010'),
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
              row.timestampFormatted,
              '${row.humidity.toStringAsFixed(1)}%',
              '${row.temperature.toStringAsFixed(1)}°C',
              '${row.duration.toStringAsFixed(1)}',
              row.keterangan,
            ]).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
