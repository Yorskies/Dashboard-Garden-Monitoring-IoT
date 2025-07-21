import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tanaman_provider.dart';
import '../widgets/header.dart';
import '../widgets/form_tambah_tanaman.dart';
import '../widgets/tanaman_detail_card.dart';

class DataTanamanPage extends StatelessWidget {
  const DataTanamanPage({Key? key}) : super(key: key);

  void _tampilkanFormTambah(BuildContext context, {Map<String, String>? dataEdit, int? indexEdit}) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: 400,
            child: FormTambahTanaman(
              initialData: dataEdit,
              indexEdit: indexEdit,
            ),
          ),
        );
      },
    );
  }

  void _tampilkanDetailTanaman(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: 400,
            child: TanamanDetailCard(
              indexTanaman: index,
              onClose: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tanamanProvider = Provider.of<TanamanProvider>(context);
    final dataTanaman = tanamanProvider.daftarTanaman;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(title: 'Data Tanaman'),
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
                        onPressed: () => _tampilkanFormTambah(context),
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
                      0: FlexColumnWidth(1.8),
                      1: FlexColumnWidth(1.5),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(2.5),
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: Colors.greenAccent),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
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
                                child: Text(tanaman['nama'] ?? '-'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(tanaman['tinggi'] ?? '-'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(tanaman['usia'] ?? '-'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(tanaman['warna'] ?? '-'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _tampilkanDetailTanaman(context, index),
                                      child: const Text('Detail'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _tampilkanFormTambah(
                                        context,
                                        dataEdit: Map<String, String>.from(tanaman),
                                        indexEdit: index,
                                      ),
                                      child: const Text('Edit'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => tanamanProvider.deleteTanaman(index),
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
