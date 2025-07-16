import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onMenuTap;
  final String selectedMenu;

  const Sidebar({
    Key? key,
    required this.onMenuTap,
    required this.selectedMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> menuItems = [
      {'title': 'Dashboard', 'icon': Icons.dashboard},
      {'title': 'Data Tanaman', 'icon': Icons.eco},
      {'title': 'Simulasi', 'icon': Icons.animation},
      {'title': 'Logika Fuzzy', 'icon': Icons.bubble_chart},
      {'title': 'Laporan', 'icon': Icons.picture_as_pdf},
    ];

    return Container(
      width: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade800, Colors.green.shade600],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 140,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade900,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Row(
              children: const [
                Icon(Icons.agriculture, color: Colors.white, size: 36),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Smart Farming',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...menuItems.map((item) => _buildMenuItem(item['title'], item['icon'])).toList(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '© 2025 STMIK Pelita Nusantara Medan',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    final bool isSelected = selectedMenu == title;

    return InkWell(
      onTap: () => onMenuTap(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade900 : Colors.transparent,
          border: isSelected
              ? const Border(
                  left: BorderSide(color: Colors.white, width: 4),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
