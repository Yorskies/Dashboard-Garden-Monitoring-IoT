import 'package:flutter/material.dart';
import '../widgets/header.dart';

class LogikaFuzzyPage extends StatefulWidget {
  const LogikaFuzzyPage({Key? key}) : super(key: key);

  @override
  State<LogikaFuzzyPage> createState() => _LogikaFuzzyPageState();
}

class _LogikaFuzzyPageState extends State<LogikaFuzzyPage> {
  final TextEditingController kelembabanController = TextEditingController();
  final TextEditingController suhuController = TextEditingController();

  double? hasilFuzzy;
  String keterangan = '';

  void prosesFuzzy() {
    final double? kelembaban = double.tryParse(kelembabanController.text);
    final double? suhu = double.tryParse(suhuController.text);

    if (kelembaban == null || suhu == null) {
      setState(() {
        hasilFuzzy = null;
        keterangan = 'Masukkan nilai yang valid!';
      });
      return;
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

    setState(() {
      hasilFuzzy = output;
      if (output == 0) {
        keterangan = 'Tidak perlu disiram';
      } else {
        keterangan = 'Disiram selama ${output.toStringAsFixed(1)} detik';
      }
    });
  }

  double fuzzyMembership(double x, double a, double b, double c) {
    if (x <= a || x >= c) return 0;
    if (x == b) return 1;
    if (x < b) return (x - a) / (b - a);
    return (c - x) / (c - b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Header(title: 'Logika Fuzzy'),
            const SizedBox(height: 24),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📘 Deskripsi Logika Fuzzy',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sistem ini menggunakan metode Fuzzy Sugeno untuk menentukan durasi penyiraman tanaman berdasarkan suhu dan kelembaban tanah.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Divider(height: 32),
                    const Text(
                      '📈 Grafik Fungsi Keanggotaan',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/fuzzy_membership_chart.png',
                          height: 400,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    const Text(
                      '📊 Parameter Fungsi Keanggotaan',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(columns: const [
                        DataColumn(label: Text('Variabel')),
                        DataColumn(label: Text('Kategori')),
                        DataColumn(label: Text('Rentang')),
                      ], rows: const [
                        DataRow(cells: [
                          DataCell(Text('Kelembaban Tanah')),
                          DataCell(Text('Kering')),
                          DataCell(Text('0 – 60')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Kelembaban Tanah')),
                          DataCell(Text('Normal')),
                          DataCell(Text('55 – 80')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Kelembaban Tanah')),
                          DataCell(Text('Basah')),
                          DataCell(Text('80 – 100')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Suhu')),
                          DataCell(Text('Dingin')),
                          DataCell(Text('0 – 20')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Suhu')),
                          DataCell(Text('Sedang')),
                          DataCell(Text('15 – 30')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Suhu')),
                          DataCell(Text('Panas')),
                          DataCell(Text('25 – 35')),
                        ]),
                      ]),
                    ),
                    const Divider(height: 32),
                    const Text(
                      '🧠 Aturan Fuzzy (Sugeno Rules)',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. IF Tanah Kering AND Suhu Panas THEN Durasi = 10 detik\n'
                      '2. IF Tanah Normal AND Suhu Sedang THEN Durasi = 3 detik\n'
                      '3. IF Tanah Basah AND Suhu Dingin THEN Durasi = 0 detik',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Divider(height: 32),
                    const Text(
                      '🧮 Rumus Defuzzifikasi Sugeno',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Durasi = (w1*z1 + w2*z2 + w3*z3) / (w1 + w2 + w3)\n'
                      '• w = derajat keanggotaan minimum dari setiap rule\n'
                      '• z = nilai crisp output untuk setiap rule',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Divider(height: 32),
                    const Text(
                      '🔎 Simulasi Manual',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: kelembabanController,
                            decoration: const InputDecoration(
                              labelText: 'Kelembaban Tanah (%)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: suhuController,
                            decoration: const InputDecoration(
                              labelText: 'Suhu Udara (°C)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: prosesFuzzy,
                          child: const Text('Proses Fuzzy'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (hasilFuzzy != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hasil: ${hasilFuzzy!.toStringAsFixed(2)} detik',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Keterangan: $keterangan',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
