import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../pages/login_page.dart';

class Header extends StatelessWidget {
  final String title;
  final Function(String)? onMenuSelected; // Tambahan callback ke BaseLayout

  const Header({Key? key, required this.title, this.onMenuSelected}) : super(key: key);

  void _handleMenuAction(BuildContext context, String value) {
    if (value == 'pengaturan') {
      onMenuSelected?.call('Pengaturan'); // Ganti tab ke menu Pengaturan di BaseLayout
    } else if (value == 'logout') {
      // Reset user data
      Provider.of<UserProvider>(context, listen: false).resetUser();

      // Arahkan ke LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(context, value),
          offset: const Offset(0, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'pengaturan',
              child: Text('Pengaturan'),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
          child: Row(
            children: const [
              Icon(Icons.account_circle, size: 28),
              SizedBox(width: 8),
              Text('Admin', style: TextStyle(fontSize: 16)),
              Icon(Icons.arrow_drop_down),
              SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}
