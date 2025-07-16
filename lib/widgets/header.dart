import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;

  const Header({Key? key, required this.title}) : super(key: key);

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
        Row(
          children: [
            Icon(Icons.account_circle, size: 28),
            SizedBox(width: 8),
            Text(
              'Admin',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}
