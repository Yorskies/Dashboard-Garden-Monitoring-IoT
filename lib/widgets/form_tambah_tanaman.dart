import 'package:flutter/material.dart';

class FormTambahTanaman extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;
  final Map<String, String>? initialData;

  const FormTambahTanaman({
    Key? key,
    required this.onSubmit,
    this.initialData,
  }) : super(key: key);

  @override
  State<FormTambahTanaman> createState() => _FormTambahTanamanState();
}

class _FormTambahTanamanState extends State<FormTambahTanaman> {
  final _formKey = GlobalKey<FormState>();
  String _namaTanaman = '';
  String _jenisTanah = 'Lempung';
  String _kebutuhanAir = '';

  final List<String> jenisTanahList = ['Lempung', 'Pasir', 'Gambut', 'Liat'];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _namaTanaman = widget.initialData!['nama'] ?? '';
      _jenisTanah = widget.initialData!['tanah'] ?? 'Lempung';
      _kebutuhanAir = widget.initialData!['air'] ?? '';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit({
        'nama': _namaTanaman,
        'tanah': _jenisTanah,
        'air': _kebutuhanAir,
      });

      Navigator.of(context).pop(); // Tutup dialog setelah submit
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_circle_outline, color: Colors.green, size: 26),
                  const SizedBox(width: 10),
                  Text(
                    widget.initialData != null ? "Edit Tanaman" : "Form Tambah Tanaman",
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

              DropdownButtonFormField<String>(
                value: _jenisTanah,
                decoration: const InputDecoration(
                  labelText: 'Jenis Tanah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.terrain),
                ),
                items: jenisTanahList
                    .map((jenis) => DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _jenisTanah = val);
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _kebutuhanAir,
                decoration: const InputDecoration(
                  labelText: 'Kebutuhan Air (ml/hari)',
                  hintText: 'Contoh: 200',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.water_drop),
                ),
                keyboardType: TextInputType.number,
                onSaved: (val) => _kebutuhanAir = val ?? '',
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
    );
  }
}
