import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/form_tambah_tanaman.dart';
import '../widgets/tanaman_detail_card.dart';

class DataTanamanPage extends StatefulWidget {
  const DataTanamanPage({Key? key}) : super(key: key);

  @override
  State<DataTanamanPage> createState() => _DataTanamanPageState();
}

class _DataTanamanPageState extends State<DataTanamanPage> {
  final List<Map<String, String>> dataTanaman = [
    {'tinggi': '15 cm', 'usia': '7 hari', 'warna': 'Hijau Cerah'},
    {'tinggi': '23 cm', 'usia': '14 hari', 'warna': 'Hijau Tua'},
    {'tinggi': '10 cm', 'usia': '5 hari', 'warna': 'Hijau Pucat'},
  ];

  void _tampilkanFormTambah({Map<String, String>? dataEdit, int? indexEdit}) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: 400,
            child: FormTambahTanaman(
              initialData: dataEdit,
              onSubmit: (dataBaru) {
                setState(() {
                  if (indexEdit != null) {
                    dataTanaman[indexEdit] = {
                      'tinggi': dataBaru['tinggi'] ?? '',
                      'usia': dataBaru['usia'] ?? '',
                      'warna': dataBaru['warna'] ?? '',
                    };
                  } else {
                    dataTanaman.add({
                      'tinggi': '${(10 + dataTanaman.length * 2)} cm',
                      'usia': '${(dataTanaman.length * 3) + 5} hari',
                      'warna': 'Hijau Random',
                    });
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  void _tampilkanDetailTanaman(Map<String, String> tanaman) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: 400,
            child: TanamanDetailCard(
              tanaman: tanaman,
              onClose: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(title: 'Data Tanaman'), // tetap di atas
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar Data Tanaman',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _tampilkanFormTambah(),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Tanaman'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade400),
                    columnWidths: const {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(1.5),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2.5),
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: Colors.greenAccent),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Tinggi', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Usia', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Warna', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...dataTanaman.asMap().entries.map(
                        (entry) {
                          final index = entry.key;
                          final tanaman = entry.value;

                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(tanaman['tinggi']!),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(tanaman['usia']!),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(tanaman['warna']!),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _tampilkanDetailTanaman(tanaman),
                                      child: const Text('Detail'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _tampilkanFormTambah(
                                          dataEdit: tanaman,
                                          indexEdit: index,
                                        );
                                      },
                                      child: const Text('Edit'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          dataTanaman.removeAt(index);
                                        });
                                      },
                                      child: const Text('Hapus'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
