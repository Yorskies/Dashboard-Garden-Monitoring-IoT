import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/data_tanaman_page.dart';
import 'pages/laporan_page.dart';
import 'pages/pengaturan_page.dart';
import 'pages/simulasi_page.dart';
import 'pages/logka_fuzzy_page.dart';
import 'widgets/sidebar.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({Key? key}) : super(key: key);

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  // Daftar menu
  final List<String> menuTitles = [
    'Dashboard',
    'Data Tanaman',
    'Simulasi',
    'Logika Fuzzy',
    'Laporan',
    'Pengaturan',
  ];

  int selectedIndex = 0;

  // Callback dari Header di halaman
  void _handleHeaderMenu(String menu) {
    if (menuTitles.contains(menu)) {
      setState(() {
        selectedIndex = menuTitles.indexOf(menu);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedMenu: menuTitles[selectedIndex],
            onMenuTap: (menu) {
              setState(() {
                selectedIndex = menuTitles.indexOf(menu);
              });
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: IndexedStack(
                index: selectedIndex,
                children: [
                  DashboardPage(onMenuSelected: _handleHeaderMenu),
                  DataTanamanPage(onMenuSelected: _handleHeaderMenu),
                  SimulasiPage(onMenuSelected: _handleHeaderMenu),
                  LogikaFuzzyPage(onMenuSelected: _handleHeaderMenu),
                  LaporanPage(onMenuSelected: _handleHeaderMenu),
                  PengaturanPage(onMenuSelected: _handleHeaderMenu),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
