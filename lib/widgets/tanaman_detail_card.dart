import 'package:flutter/material.dart';

class TanamanDetailCard extends StatelessWidget {
  final Map<String, String> tanaman;
  final VoidCallback? onClose;

  const TanamanDetailCard({
    Key? key,
    required this.tanaman,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
