import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tanaman_provider.dart';

class FormTambahTanaman extends StatefulWidget {
  final Map<String, String>? initialData;
  final int? indexEdit;

  const FormTambahTanaman({
    Key? key,
    this.initialData,
    this.indexEdit,
  }) : super(key: key);

  @override
  State<FormTambahTanaman> createState() => _FormTambahTanamanState();
}

class _FormTambahTanamanState extends State<FormTambahTanaman> {
  final _formKey = GlobalKey<FormState>();
  String _namaTanaman = '';
  String _tinggi = '';
  String _usia = '';
  String _warna = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _namaTanaman = widget.initialData!['nama'] ?? '';
      _tinggi = widget.initialData!['tinggi'] ?? '';
      _usia = widget.initialData!['usia'] ?? '';
      _warna = widget.initialData!['warna'] ?? '';
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final data = {
        'nama': _namaTanaman,
        'tinggi': _tinggi,
        'usia': _usia,
        'warna': _warna,
        'gambar': '', // Kosong karena gambar tidak digunakan
      };

      final provider = Provider.of<TanamanProvider>(context, listen: false);

      if (widget.indexEdit != null) {
        await provider.updateTanaman(widget.indexEdit!, data);
      } else {
        await provider.addTanaman(data);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialData != null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.add_circle_outline, color: Colors.green, size: 26),
                    const SizedBox(width: 10),
                    Text(
                      isEdit ? "Edit Tanaman" : "Form Tambah Tanaman",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(height: 24, thickness: 1),

                TextFormField(
                  initialValue: _namaTanaman,
                  decoration: const InputDecoration(
                    labelText: 'Nama Tanaman',
                    hintText: 'Contoh: Bayam, Kangkung, Cabai...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_florist),
                  ),
                  onSaved: (val) => _namaTanaman = val ?? '',
                  validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  initialValue: _tinggi,
                  decoration: const InputDecoration(
                    labelText: 'Tinggi Tanaman',
                    hintText: 'Contoh: 15 cm',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.height),
                  ),
                  onSaved: (val) => _tinggi = val ?? '',
                  validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  initialValue: _usia,
                  decoration: const InputDecoration(
                    labelText: 'Usia Tanaman',
                    hintText: 'Contoh: 7 hari',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onSaved: (val) => _usia = val ?? '',
                  validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  initialValue: _warna,
                  decoration: const InputDecoration(
                    labelText: 'Warna Daun',
                    hintText: 'Contoh: Hijau Cerah',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.palette),
                  ),
                  onSaved: (val) => _warna = val ?? '',
                  validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                ),

                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text("Simpan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
