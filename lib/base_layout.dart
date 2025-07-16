import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/data_tanaman_page.dart';
import 'pages/laporan_page.dart';
import 'pages/simulasi_page.dart';
import 'pages/logka_fuzzy_page.dart';
import 'widgets/sidebar.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({Key? key}) : super(key: key);

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  String selectedMenu = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    switch (selectedMenu) {
      case 'Data Tanaman':
        currentPage = const DataTanamanPage();
        break;
      case 'Simulasi':
        currentPage = const SimulasiPage();
        break;
      case 'Logika Fuzzy':
        currentPage = const LogikaFuzzyPage();
        break;
      case 'Laporan':
        currentPage = const LaporanPage();
        break;
      default:
        currentPage = const DashboardPage();
    }

    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedMenu: selectedMenu,
            onMenuTap: (menu) {
              setState(() {
                selectedMenu = menu;
              });
            },
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
              child: Container(
                key: ValueKey<String>(selectedMenu),
                padding: const EdgeInsets.all(24.0),
                child: currentPage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
