import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tanaman_provider.dart';

class TanamanDetailCard extends StatelessWidget {
  final int indexTanaman;
  final VoidCallback? onClose;

  const TanamanDetailCard({
    Key? key,
    required this.indexTanaman,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tanamanProvider = Provider.of<TanamanProvider>(context);
    final tanaman = tanamanProvider.daftarTanaman[indexTanaman];

    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detail Tanaman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Detail Info
            _buildDetailRow('Nama Tanaman:', tanaman['nama'] ?? ''),
            _buildDetailRow('Tinggi Tanaman:', tanaman['tinggi'] ?? ''),
            _buildDetailRow('Usia Tanaman:', tanaman['usia'] ?? ''),
            _buildDetailRow('Warna Daun:', tanaman['warna'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
